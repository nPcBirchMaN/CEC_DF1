trigger OrderwooCommerce on Order (before insert, after insert, before update)
{
    Set<Id> orderId = new Set<Id>(); 								//Set para buscar las líneas de pedidos
	Set<Id> productId = new Set<Id>();								//Set para buscar los productos a los que actualizar las plazas disponibles
    Map<Id, Decimal> productQuantity = new Map<Id, Decimal>(); 		//Mapa que almacena la relación producto - cantidad comprada
    List<Product2> productsNewStock = new List<Product2>();			//Lista que contiene los productos a actualizar

    Map<Id, String> orderExtras = new Map<Id, String>();
    Map<Id, String> orderExtrasName = new Map<Id, String>();
    Set<String> orderItemName = new Set<String>();
    List<OrderItem> listaInsertProductos = new List<OrderItem>();
    Set<Id> cuentas = new Set<Id>();
    Map<Id, Id> orderLicencia = new Map<Id,Id>();
    Map<Id, Id> cuentaLicencia = new Map<Id,Id>();
    Map<Id, Id> cuentaOrder = new Map<Id,Id>();

    System.debug('OrderwooCommerce');
	for (Order ord: trigger.new)
    {
        if (Trigger.isInsert) {
            if (Trigger.isAfter) {
                if (ord.webkul_wws__woo_Order_Number__c > 0 && ord.webkul_wws__Woo_Order_Status__c == 'wc-pending')
                {
                    //Si el pedido tiene extras, los guardamos en un map que identifica el pedido con los extras
                    if (ord.Extras__c != null){
                        orderExtras.put(ord.Id, ord.Extras__c);
                        cuentaOrder.put(ord.AccountId, ord.Id);
                    }

                }
            } else {
                if (ord.webkul_wws__woo_Order_Number__c > 0 && ord.webkul_wws__Woo_Order_Status__c == 'wc-pending')
                {
                    ord.Etapa__c='2.Negociación';
                    ord.Tipo_de_Pago__c = 'Web';

                }
            }

        } else {
            //Al actualizarse un pedido que viene del eCommerce, si está completado, lo cerramos y activamos
            if (ord.webkul_wws__woo_Order_Number__c > 0 && ord.webkul_wws__Woo_Order_Status__c == 'wc-completed') {
                ord.Etapa__c='3.Cerrada';
                ord.Cerrado__c = true;
                ord.status = 'Activado';
            }
        }
        //En el caso de venir de WooCommerce el campo 'webkul_wws__woo_Order_Number__c' del pedido vendrá relleno
        if (ord.webkul_wws__woo_Order_Number__c > 0 && ord.Etapa__c=='3.Cerrada' && ord.Stock_contabilizado__c == false)
        {
            //Guardamos en un Set los id de los pedidos que vengan de wooCommerce
            orderId.add(ord.Id);
            //Marcamos que el stock del pedido ha sido contabilizado, para que si se actualiza el pedido, no se reste otra vez el stock
            ord.Stock_contabilizado__c = true;
        }
     }
    //Si hay extras en los pedidos
    if (orderExtras.size() > 0) {
        //Recuperamos los productos extra del pedido
        for(String key:orderExtras.keySet()){
            Map<String, Id> extrasPedido = new Map<String, Id>();
            String extraName = '';
            //Los extra, tienen el formato: [tipo|nombre|precio;|tipo|nombre|precio;...]
            //En extras guardamos toda la información de cada producto, para ello los recuperamos todos separandolos por ';'
            String[] extras = orderExtras.get(key).split(';');
            //Recorremos todos los productos, para recuperar sus nombres y así poder recuperarlos en SF
            for (Integer i=0; i < extras.size(); i++) {
                //En extra guardamos cada producto extra
                String extra = extras[i];
                //Sustituimos los '-' por espacios (' ')
                extra = extra.replaceAll('-', ' ');
                //Separamos cada parte del producto separandolos por '|'
                String[] nombreExtra = extra.split('\\|');
                if (nombreExtra[1].contains('matricula')) {
                    nombreExtra[1] = 'matrícula';
                }
                if (nombreExtra[1].contains('habilitacio')) {
                    nombreExtra[1] = nombreExtra[1].replace('habilitacio','habilitació');
                }
                if (nombreExtra[1].contains('plus')) {
                    nombreExtra[1] = nombreExtra[1].replace('plus','Plus');
                }
                if (nombreExtra[1].contains('18 74')) {
                    nombreExtra[1] = nombreExtra[1].replace('18 74','18-74');
                }
                if (nombreExtra[1].contains('fedme')) {
                    nombreExtra[1] = nombreExtra[1].replace('fedme','FEDME');
                }
                //Guardamos en orderItemName el nombre del producto con la primera letra en mayúsculas para hacer la búsqueda por nombre posteriormente
                orderItemName.add(nombreExtra[1].capitalize());
                //Creamos un String con todos los extra del pedido separados por '|'. El string contiene el nombre del producto y el precio que viene de la web separados por ' - '
                extraName = extraName + ((i!=0)?'|':'') + (nombreExtra[1].capitalize()+' - '+nombreExtra[2]);
            }
            //Guardamos en orderExtrasName el pedido y los nombres de los productos extra con su precio para su posterior utilización
            orderExtrasName.put(key, extraName);
        }
        System.debug('orderItemName :: ' + orderItemName);
        if (orderItemName.size() > 0) {
            List<Product2> listaProductos = new List<Product2>();
            //Recuperamos todos los productos extra que tiene el pedido recuperándolos de orderItemName, donde hemos guardado los nombres de todos los productos extra
            if (Test.isRunningTest()) {
                listaProductos = [Select Id, Name, Licencia__c, (Select Id, UnitPrice From PricebookEntries) From Product2 Where Product_type__c = 'subscription'
                                             And isActive = true And Name IN : orderItemName];
            } else {
                listaProductos = [Select Id, Name, Licencia__c, (Select Id, UnitPrice From PricebookEntries Where Pricebook2.Name = 'Standard Price Book') From Product2
                                  Where Product_type__c = 'subscription' And isActive = true And Name IN : orderItemName];
            }
            System.debug('listaProductos '+listaProductos);
            for(Id key:orderExtrasName.keySet()){
                //Recuperamos los productos extra que van en este pedido
                String prodName = orderExtrasName.get(key);
                System.debug('prodName :: ' + prodName);
                System.debug('listaProductos :: ' + listaProductos);
                for (Product2 prod : listaProductos) {
                    //Comprobamos que el producto está en el pedido que corresponde
					System.debug('(prod.Name :: ' + prod.Name);
                    if (prodName.contains(prod.Name) == true) {
                        //Creamos el nuevo producto
                        OrderItem oItem = new OrderItem();
                        oItem.Product2Id = prod.Id;
                        oItem.Quantity = 1;
                        oItem.OrderId = key;
                        /*String[] productos = prodName.split('\\|');
                        for (Integer i=0; i<productos.size(); i++) {
                            String[] producto = productos[i].split('-');
                            //Asignamos el precio que viene por la web
                            if (producto[0].trim().equals(prod.Name.trim())) {
                                oItem.UnitPrice = Decimal.valueOf(producto[1].replaceAll(' ', ''));
                            }
                        }*/
                        system.debug('prod.PricebookEntries '+prod.PricebookEntries);
                        //Asignamos la lista de precios estandar por venir de la web y el precio
                        for (PricebookEntry precios : prod.PricebookEntries) {
                            oItem.PricebookEntryId = precios.Id;
                            oItem.UnitPrice = precios.UnitPrice;
                        }
                        //Añadimos el producto nuevo a la lista de inserción
                        listaInsertProductos.add(oItem);

                        //Si el producto es una licencia FEEC la guardamos para poder asignarseal al cliente
                        if (prod.Licencia__c == true) {
                            //System.debug('prod.Licencia__c ' +prod.Licencia__c);
                            orderLicencia.put(key, prod.Id);
                        }
                    }
                }
            }
            if (listaInsertProductos.size() > 0) {
                //Insertamos los productos extra
                Database.insert(listaInsertProductos);
            }
        }
    }

    if (orderLicencia.size() > 0) {
        //System.debug('orderLicencia' + orderLicencia);
        for (Id orderKey : orderLicencia.keySet()) {
            //System.debug('orderKey '+orderKey);
            for (Id cuentaKey : cuentaOrder.keySet()) {
                //System.debug('cuentaKey '+cuentaKey);
                Id orderId = cuentaOrder.get(cuentaKey);
                //System.debug('orderId '+orderId);
                if (orderId == orderKey) {
                    cuentas.add(cuentaKey);
                    cuentaLicencia.put(cuentaKey, orderLicencia.get(orderKey));
                }
            }
        }

        if (cuentas.size() > 0) {
            List<Account> listaCuentas = [Select Id, Licencia__c From Account Where Id = :cuentas];
            //System.debug('listaCuentas' +listaCuentas);
            for (Account updateAccount : listaCuentas) {
                //System.debug('Licencia: '+cuentaLicencia.get(updateAccount.Id));
                updateAccount.Licencia__c = cuentaLicencia.get(updateAccount.Id);
            }

            if (listaCuentas.size() > 0) {
                Database.update(listaCuentas);
            }
        }
    }

    if (orderId.size() > 0) {
        //Recuperamos las líneas de pedido de todos los pedidos que vienen de wooCommerce
        List<OrderItem> lineasPedido = [Select Id,Product2.Product_type__c, Product2.Role_to_assign__c, Product2.Name, OrderId, Product2Id, Quantity From OrderItem
                                        Where OrderId = : orderId];
        //System.debug('lineasPedido '+lineasPedido);
        for (OrderItem linPedido : lineasPedido) {
            //System.debug('linPedido :: ' + linPedido);
            //Comprobamos que llegue algún producto de tipo suscripción
            if (linPedido.Product2.Product_type__c != 'subscription') {
                //Guardamos los productos que se han comprado en el eCommerce, para restarles la cantidad comprada al stock
                productId.add(linPedido.Product2Id);
                productQuantity.put(linPedido.Product2Id, linPedido.Quantity);
            }
        }
        if (productId.size() > 0) {
            List<Product2> listaProductos = [Select id, Plazas_Disponibles__c From Product2 Where Id=:productId];
            for (Product2 producto : listaProductos) {
                Decimal cantidad = productQuantity.get(producto.Id);
                //System.debug('cantidad '+cantidad);
                producto.Plazas_disponibles__c = producto.Plazas_disponibles__c - cantidad;
                productsNewStock.add(producto);
            }
        }
        if (productsNewStock.size() > 0) {
            Database.update(productsNewStock);
        }
	}
    /*if (Trigger.isInsert && Trigger.isAfter)
    {
        System.debug('verificamos integridad de precios');
        List<OrderItem> orderItemList = new List<OrderItem>();
        List<OrderItem> orderItemList2Upd = new List<OrderItem>();
        System.debug('Tamaño SET:'+orderIntegrityId.size());
        orderItemList = [SELECT Id,Product2Id,UnitPrice,CategoriaCliente__c from OrderItem where OrderId IN :orderIntegrityId];
        System.debug('Tamaño SET:'+orderItemList.size());
        String categoria;
        decimal price=0.0;
        for(OrderItem oi:orderItemList)
        {
            System.debug('Categoria cliente:'+oi.CategoriaCliente__c);
            if(oi.CategoriaCliente__c=='No_soci')
				categoria='No socio';
			if(oi.CategoriaCliente__c=='Participatiu')
				categoria='Socios';
			if(oi.CategoriaCliente__c=='Ple_dret')
				categoria='Socio participativo';

            System.debug('Lista a aplicar:'+categoria);
            List<PriceBookentry> pBE = [SELECT Name,Pricebook2Id,Product2Id,UnitPrice,Pricebook2.Name FROM PricebookEntry where Product2Id=:oi.Product2Id];
            System.debug('Tamaño:'+pBE.size());
           	for (PriceBookEntry pr:pBE)
            {
                if(pr.Pricebook2.Name==categoria)
                {
                    price=pr.UnitPrice;
                    System.debug('Precio cetegoria:'+price);
                    break;
                }
                else if(pr.Pricebook2.Name=='Standard Price Book')
                {
                    price=pr.UnitPrice;
                    System.debug('Precio standard:'+price);
                }

            }
            System.debug('Precio final:'+price);
			oi.UnitPrice = price;
            orderItemList2Upd.add(oi);
        }
        Database.update(orderItemList2Upd,false);

    }*/

}