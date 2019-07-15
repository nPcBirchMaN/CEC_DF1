global with sharing  class ProductSynchro {
    @AuraEnabled
    webservice static String ProductSynchronization(String ProdId, String Modo) 
    {
        System.debug('ProdId '+ProdId);
        System.debug('modo '+Modo);//Modo Alta o Cancelar
        String message = 'Error en la sincronización.';
        BirchmanGeneralAPI birchAPI = new BirchmanGeneralAPI();
        CECProductsAPI.ProductsData productData = new CECProductsAPI.ProductsData();
        CECProductsAPI.ProductsData productDataResponse = new CECProductsAPI.ProductsData();
        CECProductsAPI.ProductsData_Z cecProductsAPIZ = new CECProductsAPI.ProductsData_Z();
        CECProductsAPI.ProductsData_Z cecProductsAPIZResponse = new CECProductsAPI.ProductsData_Z();
        List<String> credentialList = new List<String>();
        String responseBody = '';
        
        //Buscamos toda la información que necesitamos del producto a sincronizar
        Product2 producto = [SELECT id, webkul_wws__woo_Post_id__c, Name, ProductCode, Descripci_n_completa__c, Description, webkul_wws__woo_post_Status__c, Plazas_Disponibles__c, 
							Coordinada_por__c, Datos_de_encuentros__c, Dirigido_por__c, Estados__c, Fecha_de_fin__c, Fecha_de_inicio__c, Final_inscripci_n__c, Plazas_totales__c,
                            Inicio_inscripci_n__c, Grado_de_dificultad__c, Organizador__c, Reuni_n_Previa__c, Dirigido_a_familias__c, Dirigido_a_j_venes__c, Dirigido_a_ninos__c, 
                            Dirigido_a_seniors__c, Product_type__c, Activity_type__c, Role_to_assign__c, Impedir_Compra_No_Socio__c, Impedir_Compra_Socio__c, IsActive,
                            Impedir_Compra_Socio_Participativo__c, cec_disc_soci__c, cec_disc_soci_participatiu__c, sold_individually__c, ECommerce__c, tax_status__c, tax_class__c,
                            Gu_a_con_formulario_de_contacto__c, webkul_wws__Woo_Post_Description__c, webkul_wws__woo_Post_excerpt__c FROM Product2 WHERE ID=:ProdId ];
        
        if (producto.ECommerce__c == true && Modo != 'Cancelar') {
            //Buscamos las listas de precios para el producto a sincronizar
            List<PricebookEntry> priceBookList = [SELECT id, Pricebook2Id,Product2Id,ProductCode,UnitPrice,UseStandardPrice, Pricebook2.Name, Pricebook2.IsActive 
                                                  FROM PricebookEntry WHERE Product2Id =: ProdId];
            
            System.debug('Pricebook: '+ priceBookList);
            
            /************************* Creamos la cabecera para la integración *******************************/
            //Si ya tenemos el webkul_wws__woo_Post_id__c relleno, es que vamos a hacer una actualización
            String idProducto = (producto.webkul_wws__woo_Post_id__c == null) ? '' : String.valueOf(producto.webkul_wws__woo_Post_id__c);
            
            //POST cuando se cree nuevo producto/ PUT para actualizar producto
            String strHttpMethod = (idProducto == '') ? 'POST' : 'PUT';
            //System.debug('strHttpMethod '+strHttpMethod);
            String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
            String strEndPoint = Label.strEndPoint + 'products/';
            //en caso de PUT, se la añade el PostId de wooCommerce en la url
            strEndPoint = strEndPoint + idProducto;
            //System.debug('strEndPoint '+strEndPoint);
            
            /************************* Creamos el cuerpo para la integración *******************************/
            //Rellenamos el productData con toda la información obtenida mediante query
            productData = CECProductsAPI.RellenarProductDataDesdeProducto(producto, priceBookList, Modo);
            cecProductsAPIZ.ProductsData = productData;
            
            String strBody=JSON.serialize(productData, true);
            String stringBody=JSON.serialize(productData, true);
            Boolean isVirtual = (producto.Product_type__c == 'merchandising') ? false : true;
            strBody = strBody.substringBeforeLast('}');
            strBody = strBody + ',\"virtual\": \"'+isVirtual+'\"}';
            System.debug('strBody '+strBody);
            
            /************************* Llamada a la API *******************************/
            responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
            System.debug('responseBody '+responseBody);
            /************************* Tratamos la respuesta *******************************/
            cecProductsAPIZResponse = CECProductsAPI.parse(responseBody);
            System.debug('cecProductsAPIZResponse '+cecProductsAPIZResponse);
            //Guardamos en wooPostId el id del producto en wooCommerce
            Decimal wooPostId = cecProductsAPIZResponse.id;
            System.debug('wooProductId '+wooPostId);
            
            CECProductsAPI.ResponseData responseData = new CECProductsAPI.ResponseData();
            responseData = cecProductsAPIZResponse.data;
            
            /************************* Se guarda el Id de WooCommerce del producto *******************************/
            if (cecProductsAPIZResponse.data == null) {
                //Si todo ha ido correctamente, dispondremos del id del producto en wooCommerce y lo almacenaremos en 'webkul_wws__woo_Post_id__c'
                if (wooPostId != null) {
                    producto.webkul_wws__woo_Post_id__c = wooPostId;
                    //System.debug('ID del producto '+producto.webkul_wws__woo_Post_id__c);
                    database.update (producto);
                    message = (modo == 'Alta') ? 'Producto sincronizado correctamente. ' : 'Producto cancelado correctamente. ';
                }
            } 
            else {
                //Si ha habido algún error lo recuperamos
                if (cecProductsAPIZResponse.code != null && responseData.resource_id == null) {
                    message = message + ' El producto está mal sincronizado con el eCommerce, solicitar al administrador del eCommerce que compruebe la sincronización.';
                } else {
                    wooPostId = decimal.valueOf(responseData.resource_id);
                    message = message + ': ' +cecProductsAPIZResponse.message;
                    System.debug('responseData.status '+responseData.status);
                    //Aún habiendo algún error, si disponemos del id del producto en wooCommerce, y en SF aún no está almacenado, lo guardamos
                    if (wooPostId != null && producto.webkul_wws__woo_Post_id__c == null) {
                        producto.webkul_wws__woo_Post_id__c = wooPostId;
                        //System.debug('ID del producto '+producto.webkul_wws__woo_Post_id__c);
                        database.update (producto);
                    }
                }                
            }
            
            System.debug('message '+message);
    	} 
        else if (Modo != 'Cancelar') {
            message = 'El producto no se puede sincronizar porque no se vende en el eCommerce';
        } else {
            message = '';
        }
        
        //Si el producto se ha cancelado, hay que enviar emails a los compradores para notificarles que se ha cancelado
        if (Modo == 'Cancelar' && producto.IsActive == true) {
            System.debug('Cancelado el producto, enviar emails');
            producto.Estados__c = 'Cancelada';
            producto.IsActive = False;
            producto.Plazas_disponibles__c = 0;
            
            
            
            //Buscamos las listas de precios para el producto a sincronizar
            List<PricebookEntry> priceBookList = [SELECT id, Pricebook2Id,Product2Id,ProductCode,UnitPrice,UseStandardPrice, Pricebook2.Name, Pricebook2.IsActive 
                                                  FROM PricebookEntry WHERE Product2Id =: ProdId];
            /************************* Creamos la cabecera para la integración *******************************/
            //Si ya tenemos el webkul_wws__woo_Post_id__c relleno, es que vamos a hacer una actualización
            String idProducto = (producto.webkul_wws__woo_Post_id__c == null) ? '' : String.valueOf(producto.webkul_wws__woo_Post_id__c);
            System.debug('idProductoC '+idProducto);
            //POST cuando se cree nuevo producto/ PUT para actualizar producto
            String strHttpMethod = (idProducto == '') ? 'POST' : 'PUT';
            //System.debug('strHttpMethod '+strHttpMethod);
            String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
            String strEndPoint = Label.strEndPoint + 'products/';
            //en caso de PUT, se la añade el PostId de wooCommerce en la url
            strEndPoint = strEndPoint + idProducto;
            //System.debug('strEndPoint '+strEndPoint);
            //Rellenamos el productData con toda la información obtenida mediante query
            productData = CECProductsAPI.RellenarProductDataDesdeProducto(producto, priceBookList, Modo);
            String strBody=JSON.serialize(productData, true);
            String stringBody=JSON.serialize(productData, true);
            Boolean isVirtual = (producto.Product_type__c == 'merchandising') ? false : true;
            strBody = strBody.substringBeforeLast('}');
            strBody = strBody + ',\"virtual\": \"'+isVirtual+'\"}';
            System.debug('strBodyC '+strBody);
            /************************* Llamada a la API *******************************/
            responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
            System.debug('responseBodyC '+responseBody);
            
            producto.Name = 'Anul·lada ' + producto.Name;
            database.update (producto);
            
            Date fechaInicio = producto.Fecha_de_inicio__c;
            Date fechaFin = producto.Fecha_de_fin__c;
            Datetime fechaInicioDate = (fechaInicio != null)? DateTime.newInstance(fechaInicio.year(), fechaInicio.month(), fechaInicio.day()) : null;
            Datetime fechaFinDate = (fechaFin != null)? DateTime.newInstance(fechaFin.year(), fechaFin.month(), fechaFin.day()) : null;
            String inicioString = (fechaInicioDate != null)? fechaInicioDate.format('dd/MM/yyyy') : '';
            String finString = (fechaFinDate != null)? fechaFinDate.format('dd/MM/yyyy') : '';
            String fechas = ((producto.Product_type__c == 'activity' || producto.Product_type__c == 'guide')?(' del dia '+inicioString+((producto.Fecha_de_fin__c != null)?' al '+finString : '')): '');
            //Enviamos el email de notificación y obtenemos el resultado
            String resultado = EnviarEmailCancelacion(ProdId, producto.Name, fechas);
            message = message + resultado;
            FacturasRectificativas(ProdId, producto.Name);
            message = message + ' Las facturas rectificativas han sido creadas.';
        } else if (Modo == 'Cancelar' && producto.IsActive == false){
            message = message + ' El producto ha sido cancelado previamente.';
        }
        System.debug('message '+message);
        return (message);
    }
   
    @AuraEnabled
    webservice static String GetProductStock(String OrderId) 
    {
        String respuesta = '';
		/* PASO 1: Obtenemos los productos del pedido ***************************************************/
        List <OrderItem> productos = [Select Id, Product2Id, Quantity, Product2.webkul_wws__woo_Post_id__c, Product2.Product_type__c, Product2.ECommerce__c, Product2.Plazas_disponibles__c,
                                      Product2.Name, Order.Etapa__c, Order.Cerrado__c, UnitPrice From OrderItem Where UnitPrice >= 0 And OrderId =: OrderId];
		System.debug('productos '+productos);
        //Para cada producto obtenemos el stock actual mediante ws y si hay suficiente, se resta la cantidad comprada en el pedido
        for (OrderItem product : productos) {
            //Sómo mirar el stock si el pedido no está cerrado
            if (product.Order.Etapa__c != '3.Cerrada' && product.Order.Cerrado__c != true) {
                //Sólo debe mirarse el stock en caso de no ser un producto de tipo suscripción
                System.debug('product.Product2.ECommerce__c '+product.Product2.ECommerce__c);
                System.debug('product.Product2.Product_type__c '+product.Product2.Product_type__c);
                if (product.Product2.webkul_wws__woo_Post_id__c != null && product.Product2.Product_type__c != 'subscription' && product.Product2.ECommerce__c == true) {
                    /* PASO 2: Obtener el stock actual del producto ***************************************************/
                    /************************* Creamos la cabecera para la integración *******************************/
                    String idProducto = String.valueOf(product.Product2.webkul_wws__woo_Post_id__c);
                    String strHttpMethod = 'GET';
                    //System.debug('strHttpMethod '+strHttpMethod);
                    String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
                    String strEndPoint = Label.strEndPoint + 'products/'+idProducto;
                    //System.debug('strEndPoint '+strEndPoint);
                    String strBody = '';
                    List<String> credentialList = new List<String>();
                    /************************* Llamada a la API *******************************/
                    BirchmanGeneralAPI birchAPI = new BirchmanGeneralAPI();
                    String responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
                    System.debug('responseBody '+responseBody);
                    /************************* Tratamos la respuesta *******************************/
                    CECProductsAPI.StockResponseData cecProductsAPIStockResponse = new CECProductsAPI.StockResponseData();
                    cecProductsAPIStockResponse = CECProductsAPI.parseStock(responseBody);
                    System.debug('cecProductsAPIStockResponse.id '+cecProductsAPIStockResponse.id);
                    if (cecProductsAPIStockResponse.code != null) {
                        //Ha habido un error de sincronización y lo mostramos por pantalla
                        System.debug('cecProductsAPIStockResponse.code'+cecProductsAPIStockResponse.code);
                        respuesta = respuesta + 'El producto "' + product.Product2.Name + '" no se encuentra en eCommerce, se debe sincronizar antes de proceder. ';
                    } else {
                        Decimal stock_quantity = cecProductsAPIStockResponse.stock_quantity;
                        System.debug('name '+cecProductsAPIStockResponse.name);
                        
                        /* PASO 3: Se comprueba que el stock disponible es suficiente para hacer la compra *******************************/
                        if (stock_quantity != null || stock_quantity > 0) {
                            if (stock_quantity >= product.Quantity) {
                                /* PASO 4: Se resta la cantidad (de la compra) al stock en wooCommerce mediante ws (se resta y se inserta el nuevo valor) **********************/
                                Decimal nuevoStock = stock_quantity - product.Quantity;
                                String resultado = ChangeProductStock(String.valueOf(cecProductsAPIStockResponse.id), nuevoStock, product.Product2.ECommerce__c);
                                System.debug('resultado '+resultado);
                            } else {
                                respuesta = respuesta + 'El producto "' + cecProductsAPIStockResponse.name + '" no tiene stock suficiente, quedan: ' + stock_quantity+'. ';
                            }
                        } else {
                            respuesta = respuesta + 'El producto "' + cecProductsAPIStockResponse.name + '" no tiene stock. ';
                        }
                    }
                }
                else if (product.Product2.Product_type__c != 'subscription' && product.Product2.ECommerce__c != true) {
                    if (product.Product2.Plazas_disponibles__c != null && product.Product2.Plazas_disponibles__c > 0) {
                    	if (product.Product2.Plazas_disponibles__c < product.Quantity) {
                            respuesta = respuesta + 'El producto "' + product.Product2.Name + '" no tiene stock suficiente, quedan: ' + product.Product2.Plazas_disponibles__c+'. ';
                        }
                        else {
                            Decimal nuevoStock = product.Product2.Plazas_disponibles__c - product.Quantity;
                            String resultado = ChangeProductStock(product.Product2Id, nuevoStock, product.Product2.ECommerce__c);
                            System.debug('resultado '+resultado);
                        }
                    } else {
                        respuesta = respuesta + 'El producto "' + product.Product2.Name + '" no tiene stock. ';
                    }
                }
                
            }
            else {
                respuesta = 'El pedido está cerrado';
                break;
            }
        }
        if (respuesta == '') {
            respuesta = 'Pedido finalizado correctamente';
            //Obtenemos el pedido para finalizarlo
            Order pedido = [Select Id, Etapa__c From Order Where Id =: OrderId];
            pedido.Etapa__c = '3.Cerrada';
            pedido.Cerrado__c = true;
            database.Update (pedido);
        }
        System.debug('Respuesta '+respuesta);
        return respuesta;	
    }
    
    @AuraEnabled
    webservice static String ChangeProductStock(String productId, Decimal stockQuantity, Boolean eCommerce) 
    {
        if (eCommerce == true) {
            /************************* Función para insertar en wooCommerce el nuevo stock mediante ws *******************************/
            //System.debug('productId '+productId);
            //System.debug('stockQuantity '+stockQuantity);
         
            /************************* Creamos la cabecera para la integración *******************************/
            String strHttpMethod = 'POST';
            //System.debug('strHttpMethod '+strHttpMethod);
            String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
            String strEndPoint = Label.strEndPoint + 'products/'+productId;
            //System.debug('strEndPoint '+strEndPoint);
            CECProductsAPI.StockData stockData = new CECProductsAPI.StockData();
            stockData.stock_quantity = stockQuantity;
            stockData.manage_stock = true;
            String strBody = JSON.serialize(stockData);
            List<String> credentialList = new List<String>();
            /************************* Llamada a la API *******************************/
            BirchmanGeneralAPI birchAPI = new BirchmanGeneralAPI();
            String responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
            //System.debug('responseBody '+responseBody);
            /************************* Tratamos la respuesta *******************************/
            CECProductsAPI.StockResponseData cecProductsAPIStockResponse = new CECProductsAPI.StockResponseData();
            System.debug(' responseBody :: ' + responseBody);
            cecProductsAPIStockResponse = CECProductsAPI.parseStock(responseBody);
            //System.debug('cecProductsAPIStockResponse.id '+cecProductsAPIStockResponse.id);    
        }
        else {
            Product2 producto = [SELECT id, Plazas_Disponibles__c FROM Product2 WHERE ID=:productId];
            producto.Plazas_disponibles__c = stockQuantity;
            Database.update(producto);
        }
        return 'El nuevo stock es de '+stockQuantity;
    }
    
    webservice static String EnviarEmailCancelacion(String productId, String productName, String fechas) 
    {
        String message = '';							//Variable para guardar el mensaje del resultado
        Set<Id> productOrder = new Set<Id>();			//Guardamos los id de los pedidos que tienen este producto para hacer la búsqueda
        Set<Id> productOpportunity = new Set<Id>();		//Guardamos los id de la oportunidades que tienen este producto para hacer la búsqueda
        Set<Id> orderAccount = new Set<Id>();			//Guardamos los id de las cuentas que han hecho los pedidos y que asisten al evento para hacer la búsqueda de sus correos electrónicos
        Set<Id> oppAccount = new Set<Id>();				//Guardamos los id de las cuentas que han creado la oportunidad para hacer la búsqueda de sus correos electrónicos
        List<String> emailList = new List<String>();		//Listado de emails al que comunicar la cancelación del producto
        String subject = 'CEC - '+productName+' Cancel·lada';
        String emailBody = '';
        PageReference vfPageRef= Page.EmailCancelacion;
        vfPageRef.getParameters().put('producto', productName);
        vfPageRef.getParameters().put('fecha', fechas);
        /*
        String emailText = '<br><br><p>Estimat/da client/a,<br><br>Li enviem aquest correu per comunicar-li que l\'activitat "<strong>'+productName+fechas+
            '</strong>" ha sigut <strong>cancel·lada</strong>, és per això que procedirem al reemborsament de l\'import íntegre de l\'activitat.<br><br>Disculpi les molèsties que això hagi pogut ocasionar.</p><br>';
        String endEmail = '<p>Salutacions cordials,</p><br><img src="http://cec.cat/wp-content/uploads/2018/07/CEC-Logo.png"alt="CEC-Logo" width="12%" /><p>Paradís, 10 · 08002 Barcelona<br>'+
            'Tel. 933 152 311<br><a href="www.cec.cat">www.cec.cat</a></p>';
*/
        if(!Test.isRunningTest()) emailBody = vfPageRef.getContent().toString();
        else emailBody = 'Mensaje de prueba.';
        
        //Obtenemos todos las líneas de pedido que tienen el producto a cancelar
        List<OrderItem> productosPedido = [Select Id, Asistente__c, OrderId From OrderItem Where Product2Id=:productId];
        //System.debug('productosPedido '+productosPedido);
        for (OrderItem prod : productosPedido) {
            productOrder.add(prod.OrderId);
            if (prod.Asistente__c != null) {
                orderAccount.add(prod.Asistente__c);
            }
        }
        //System.debug('productOrder '+productOrder);
        if (productOrder.size() > 0) {
            //Obtenemos los emails de los compradores y los almacenamos en la lista emailList para el posterior envío de la notificación
            List<Order> orderEmails = [Select Id, Account.Id, Account.Name, Account.PersonEmail From Order Where Id=:productOrder];
            for (Order order : orderEmails) {
                if (order.Account.PersonEmail != null) emailList.add(order.Account.PersonEmail); 
            }
        }
        System.debug('orderAccount '+orderAccount);
        if (orderAccount.size () > 0) {
            //Obtenemos los emails de los asistentes y los almacenamos en la lista emailList para el posterior envío de la notificación
            List<Account> accountEmails = [Select Id, Name, PersonEmail From Account Where Id =: orderAccount];
            for (Account cuenta : accountEmails) {
                if (cuenta.PersonEmail != null) emailList.add(cuenta.PersonEmail); 
            }
        }
        
        
        //Obtenemos todos las líneas de oportunidad que tienen el producto a cancelar
        List<OpportunityLineItem> productosOportunidad = [Select Id, OpportunityId From OpportunityLineItem Where Product2Id=:productId];
        for (OpportunityLineItem opp : productosOportunidad) {
            productOpportunity.add(opp.OpportunityId);
        }
        //System.debug('productOrder '+productOrder);
        if (productosOportunidad.size() > 0) {
            //Obtenemos los emails de los compradores y los almacenamos en la lista emailList para el posterior envío de la notificación
            List<Opportunity> oppEmails = [Select Id, Account.Contacto__c, Account.Name, Account.Email__c From Opportunity Where Id=:productOpportunity];
            for (Opportunity opp : oppEmails) {
                if (opp.Account.Email__c != null) emailList.add(opp.Account.Email__c);
                if (opp.Account.Contacto__c != null) oppAccount.add(opp.Account.Contacto__c);
            }
        }
        
        System.debug('oppAccount '+oppAccount);
        if (oppAccount.size () > 0) {
            //Obtenemos los emails de los asistentes y los almacenamos en la lista emailList para el posterior envío de la notificación
            List<Contact> contactEmails = [Select Id, Name, Email From Contact Where Id =: oppAccount];
            for (Contact cuenta : contactEmails) {
                if (cuenta.Email != null) emailList.add(cuenta.Email); 
            }
        }
        
        if (emailList.size () > 0) {
            //Enviamos emails de notificación de la cancelación del producto
            System.debug('Enviamos emails de notificación');
            //message = SendEmail.SendHTML(emailList, subject, emailBody);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setBccAddresses(emailList);
            mail.setSubject(subject);
            mail.setBccSender(true);
            mail.setHtmlBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });



        }
        //System.debug('emailList '+emailList);
        return message;
    }
    
    @AuraEnabled
    webservice static String CheckOrderProductsStock(String OrderId) 
    {
        String respuesta = '';
		/* PASO 1: Obtenemos los productos del pedido ***************************************************/
        List <OrderItem> productos = [Select Id, Product2Id, Quantity, Product2.Name, Product2.webkul_wws__woo_Post_id__c, Product2.Product_type__c, Product2.ECommerce__c, 
                                      Product2.Plazas_disponibles__c, Order.Etapa__c, UnitPrice From OrderItem Where UnitPrice >= 0 And OrderId =: OrderId];
		//System.debug('productos '+productos);
        //Para cada producto obtenemos el stock actual mediante ws y si hay suficiente, se resta la cantidad comprada en el pedido
        for (OrderItem product : productos) {
            //Sómo mirar el stock si el pedido no está cerrado
            if (product.Order.Etapa__c != '3.Cerrada') {
                //Sólo debe mirarse el stock en caso de no ser un producto de tipo suscripción
                //System.debug('product.Product2.ECommerce__c '+product.Product2.ECommerce__c);
                //System.debug('product.Product2.Product_type__c '+product.Product2.Product_type__c);
                if (product.Product2.webkul_wws__woo_Post_id__c != null && product.Product2.Product_type__c != 'subscription' && product.Product2.ECommerce__c == true) {
                    /* PASO 2: Obtener el stock actual del producto ***************************************************/
                    /************************* Creamos la cabecera para la integración *******************************/
                    String idProducto = String.valueOf(product.Product2.webkul_wws__woo_Post_id__c);
                    String strHttpMethod = 'GET';
                    //System.debug('strHttpMethod '+strHttpMethod);
                    String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
                    String strEndPoint = Label.strEndPoint + 'products/'+idProducto;
                    //System.debug('strEndPoint '+strEndPoint);
                    String strBody = '';
                    List<String> credentialList = new List<String>();
                    /************************* Llamada a la API *******************************/
                    BirchmanGeneralAPI birchAPI = new BirchmanGeneralAPI();
                    String responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
                    System.debug('responseBody '+responseBody);
                    /************************* Tratamos la respuesta *******************************/
                    CECProductsAPI.StockResponseData cecProductsAPIStockResponse = new CECProductsAPI.StockResponseData();
                    cecProductsAPIStockResponse = CECProductsAPI.parseStock(responseBody);
                    //System.debug('cecProductsAPIStockResponse.id '+cecProductsAPIStockResponse.id);
                    if (cecProductsAPIStockResponse.code != null) {
                        //Ha habido un error de sincronización y lo mostramos por pantalla
                        System.debug('cecProductsAPIStockResponse.code'+cecProductsAPIStockResponse.code);
                        respuesta = respuesta + 'El producto "' + product.Product2.Name + '" no se encuentra en eCommerce, se debe sincronizar antes de proceder. ';
                    } else {
                        Decimal stock_quantity = cecProductsAPIStockResponse.stock_quantity;
                        //System.debug('name '+cecProductsAPIStockResponse.name);
                        
                        /* PASO 3: Se comprueba que el stock disponible es suficiente para hacer la compra *******************************/
                        if (stock_quantity != null || stock_quantity > 0) {
                            if (stock_quantity >= product.Quantity) {
                                /* PASO 4: Se resta la cantidad (de la compra) al stock en wooCommerce mediante ws (se resta y se inserta el nuevo valor) **********************/
                                Decimal nuevoStock = stock_quantity - product.Quantity;
                                respuesta = respuesta + 'El producto "'+cecProductsAPIStockResponse.name + '" tiene stock suficiente, quedarán disponibles '+ Integer.valueOf(nuevoStock) +'. ';
                                System.debug('respuesta '+respuesta);
                            } else {
                                respuesta = respuesta + 'El producto "' + cecProductsAPIStockResponse.name + '" no tiene stock suficiente, hay disponibles ' + stock_quantity +'. ';
                            }
                        } else {
                            respuesta = respuesta + 'El producto "' + cecProductsAPIStockResponse.name + '" no tiene stock. ';
                        }
                    }
                }
                else if (product.Product2.Product_type__c != 'subscription' && product.Product2.ECommerce__c != true) {
                    if (product.Product2.Plazas_disponibles__c != null && product.Product2.Plazas_disponibles__c > 0) {
                        if (product.Product2.Plazas_disponibles__c < product.Quantity) {
                            respuesta = respuesta + 'El producto "' + product.Product2.Name + '" no tiene stock suficiente, quedan: ' + product.Product2.Plazas_disponibles__c+'. ';
                        } else {
                            respuesta = respuesta + 'El producto "' + product.Product2.Name + '" tiene stock suficiente, quedan: ' + product.Product2.Plazas_disponibles__c+'. ';
                        }
                    } else {
                        respuesta = respuesta + 'El producto "' + product.Product2.Name + '" no tiene stock. ';
                    }
                }
                else if (product.Product2.Product_type__c == 'subscription') {
                    respuesta = respuesta + 'El producto "' + product.Product2.Name + '" tiene stock suficiente. ';
                }
        	}
            else {
                respuesta = 'El pedido está cerrado';
                break;
            }
		}
        System.debug('Respuesta '+respuesta);
        return respuesta;	
    }
    
    webservice static void FacturasRectificativas(String productId, String productName) 
    {
        List<Factura__c> listaFacturas = new List<Factura__c>();			//Guardamos los id de los pedidos que tienen este producto para hacer la búsqueda
        List<L_neas_de_factura__c> listaLineasFactura = new List<L_neas_de_factura__c>();
        Set<Id> SetIdOrdOpp = new Set<Id>();
        Set<Id> SetIdFacturas = new Set<Id>();
        Set<Id> SetFacturasAnuladas = new Set<Id>();
        
        //Obtenemos todos las líneas de factura que tienen el producto cancelado para rectificarlas
        List<L_neas_de_factura__c> facturasProducto = [SELECT ID, Factura__c, Producto__c, Cantidad__c, Precio_unitario__c, Tipo_de_impuesto__c, Factura__r.Name, Factura__r.Cliente__c, 
                                                           Factura__r.Fecha_emisi_n_factura__c, Factura__r.Tipo_de_pago__c, Factura__r.Tipo_de_Factura__c, Factura__r.Id_de_Pedido__c, 
                                                           Factura__r.Id_de_Oportunidad__c FROM L_neas_de_factura__c WHERE Producto__c =:productId];
        
        List<L_neas_de_factura__c> ListpedidosAnulados = [SELECT  Factura__r.Id_de_Pedido__c FROM L_neas_de_factura__c WHERE Producto__c =:productId AND Factura__r.Tipo_de_Factura__c='Rectificativa'];
        for(L_neas_de_factura__c aux_fa :ListpedidosAnulados)
        {
            SetFacturasAnuladas.add(aux_fa.Factura__r.Id_de_Pedido__c);
        }
        for (L_neas_de_factura__c fact : facturasProducto) {
            if (fact.Factura__r.Id_de_Oportunidad__c != null) {
                SetIdOrdOpp.add(fact.Factura__r.Id_de_Oportunidad__c);
            } else if (fact.Factura__r.Id_de_Pedido__c != null  && !SetFacturasAnuladas.contains(fact.Factura__r.Id_de_Pedido__c)) {
                SetIdOrdOpp.add(fact.Factura__r.Id_de_Pedido__c);
            }
        }
        System.debug('Facturas a crear '+SetIdOrdOpp);
        for (Id ordOppId : SetIdOrdOpp) {
            for (L_neas_de_factura__c ordOpp : facturasProducto) {
                Factura__c facturaNueva = new Factura__c ();
                facturaNueva.Name = ordOpp.Factura__r.Name + ' Rectificativa';
                facturaNueva.Cliente__c = ordOpp.Factura__r.Cliente__c;
                facturaNueva.Fecha_emisi_n_factura__c = Date.today();
                //facturaNueva.Tipo_de_pago__c = ordOpp.Factura__r.Tipo_de_pago__c;
                facturaNueva.Tipo_de_Factura__c ='Rectificativa';
                facturaNueva.Id_de_Pedido__c = ordOpp.Factura__r.Id_de_Pedido__c;
                facturaNueva.Id_de_Oportunidad__c = ordOpp.Factura__r.Id_de_Oportunidad__c;
                facturaNueva.Estado__c = 'Anulada';
                facturaNueva.Anulaci_n__c = true;
                if (ordOpp.Factura__r.Id_de_Pedido__c != null && ordOpp.Factura__r.Id_de_Pedido__c == ordOppId) {
                    if (listaFacturas.size() > 0) {
                        Boolean noCrear = false;
                        for (Factura__c factura : listaFacturas) {
                            if (factura.Id_de_Pedido__c != null && factura.Id_de_Pedido__c == ordOppId) {
                                noCrear = true;
                            }
                        }
                        if (noCrear == false) {
                            listaFacturas.add(facturaNueva);
                        }
                    } else {
                        listaFacturas.add(facturaNueva);
                    }      
                } else if (ordOpp.Factura__r.Id_de_Oportunidad__c != null && ordOppId == ordOpp.Factura__r.Id_de_Oportunidad__c) {
                    if (listaFacturas.size() > 0) {
                        Boolean noCrear = false;
                        for (Factura__c factura : listaFacturas) {
                            if (factura.Id_de_Oportunidad__c != null && factura.Id_de_Oportunidad__c == ordOppId) {
                                noCrear = true;
                            }
                        }
                        if (noCrear == false) {
                            listaFacturas.add(facturaNueva);
                        }
                    } else {
                        listaFacturas.add(facturaNueva);
                    }  
                }
            }
        }
        
        
        if (listaFacturas.size() > 0) {
            //system.debug('listaFacturas' + listaFacturas);
            database.insert(listaFacturas);
                
            for (Factura__c factura: listaFacturas){                                                //A mayores, a cada factura 
                for (L_neas_de_factura__c prod: facturasProducto) {                                     //según sus productos, se crean sus correspondientes lineas de factura.
                    if ((factura.Id_de_Pedido__c == prod.Factura__r.Id_de_Pedido__c && prod.Factura__r.Id_de_Pedido__c != null) || (factura.Id_de_Oportunidad__c == prod.Factura__r.Id_de_Oportunidad__c && prod.Factura__r.Id_de_Oportunidad__c != null)) {
                        L_neas_de_factura__c lineaNueva = new L_neas_de_factura__c ();
                        lineaNueva.Factura__c = factura.Id;
                        lineaNueva.Producto__c = prod.Producto__c;
                        lineaNueva.Cantidad__c = prod.Cantidad__c;
                        lineaNueva.Precio_unitario__c = 0 - prod.Precio_unitario__c;
                        lineaNueva.Tipo_de_impuesto__c = prod.Tipo_de_impuesto__c;
                        listaLineasFactura.add(lineaNueva);                                     // y se añaden a las mismas.  
                    }  
                }
                SetIdFacturas.add(factura.Id);
            }
            
            if (listaLineasFactura.size() > 0) {
                system.debug('listaLineasFactura' + listaLineasFactura);
                database.insert(listaLineasFactura);
            } 
     
            List<Factura__c> facturasCreadas = [Select Id, Name, N_mero_de_factura__c, Tipo_de_pago__c, Tipo_de_Factura__c, Inicio_periodo_facturaci_n__c, Importe_total_factura__c, Cobrada__c, Impagada__c, 
                                            Fecha_vencimiento__c, Fecha_de_pago__c, Fecha_emisi_n_factura__c From Factura__c Where Id =: SetIdFacturas];
        
            for(Factura__c factCreada:facturasCreadas ){                                               //se genera un vencimiento automático de dicha factura...
                Vencimiento__c vencimientoNuevo = new Vencimiento__c();
                vencimientoNuevo.Factura__c = factCreada.Id;
                vencimientoNuevo.Nombre_de_la_factura__c = factCreada.Name;
                vencimientoNuevo.N_mero_de_Factura__c = factCreada.N_mero_de_factura__c;
                vencimientoNuevo.Tipo_de_factura__c = factCreada.Tipo_de_Factura__c;
                vencimientoNuevo.Tipo_de_Pago__c = factCreada.Tipo_de_pago__c;
                vencimientoNuevo.Inicio_de_Facturaci_n__c = (factCreada.Tipo_de_pago__c == 'Tarjeta' || factCreada.Tipo_de_pago__c == 'Web')? factCreada.Fecha_vencimiento__c : factCreada.Inicio_periodo_facturaci_n__c;
                vencimientoNuevo.Importe_de_factura__c = factCreada.Importe_total_factura__c;
                vencimientoNuevo.Importe_Total__c = factCreada.Importe_total_factura__c;
                vencimientoNuevo.Cobrada__c = factCreada.Cobrada__c;
                vencimientoNuevo.Impagada__c = factCreada.Impagada__c;
                vencimientoNuevo.Fecha_de_pago__c = factCreada.Fecha_de_pago__c;
                vencimientoNuevo.Fin_de_Facturaci_n__c = factCreada.Fecha_emisi_n_factura__c;
                
                String nombreFactura = factCreada.Name;
                nombreFactura = nombreFactura.removeEnd(' Rectificativa');
                if (nombreFactura.lastIndexOf('/') != -1) {
                    vencimientoNuevo.N_mero_de_pago__c = Decimal.valueOf(nombreFactura.substringAfterLast('/'));
                } else {
                    vencimientoNuevo.N_mero_de_pago__c = 1;
                }
                database.insert(vencimientoNuevo);                                             //que se insertará como relacionado a la factura.
            } 
        }
        //System.debug('emailList '+emailList);
        return;
    }
     
    @AuraEnabled
    webservice static Integer getStockByProductId(Id productId) {
        Integer stock = null;
        Product2 product;
        List<Product2> products = [SELECT webkul_wws__woo_Post_id__c,Plazas_disponibles__c,id FROM Product2 WHERE id =: productId LIMIT 1];
        if(!products.isEmpty()) {
            product = products.get(0);
            
            String idProducto = String.valueOf(product.webkul_wws__woo_Post_id__c);
            String strHttpMethod = 'GET';
            String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
        	String strEndPoint = Label.strEndPoint + 'products/'+idProducto;
            String strBody = '';
            List<String> credentialList = new List<String>();
            BirchmanGeneralAPI birchAPI = new BirchmanGeneralAPI();
            String responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
            CECProductsAPI.StockResponseData cecProductsAPIStockResponse = new CECProductsAPI.StockResponseData();
            cecProductsAPIStockResponse = CECProductsAPI.parseStock(responseBody);
            Integer stock_quantity = Integer.valueOf(cecProductsAPIStockResponse.stock_quantity);
            stock = stock_quantity;
            product.Plazas_disponibles__c=stock;
            System.debug('Actualizo');
            update product;
        }
        return stock;
    } 
    
    @AuraEnabled
    webservice static Integer getSoldsByProductId(Id productId) {
        Integer solds = null;
        Product2 product;
        List<Product2> products = [SELECT webkul_wws__woo_Post_id__c FROM Product2 WHERE id =: productId LIMIT 1];
        if(!products.isEmpty()) {
            product = products.get(0);
            
            String idProducto = String.valueOf(product.webkul_wws__woo_Post_id__c);
            String strHttpMethod = 'GET';
            String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
        	String strEndPoint = Label.strEndPoint + 'products/'+idProducto;
            String strBody = '';
            List<String> credentialList = new List<String>();
            BirchmanGeneralAPI birchAPI = new BirchmanGeneralAPI();
            String responseBody = birchAPI.callAPI(strHttpMethod, strBody, strParam,strEndPoint,credentialList);
            CECProductsAPI.StockResponseData cecProductsAPIStockResponse = new CECProductsAPI.StockResponseData();
            cecProductsAPIStockResponse = CECProductsAPI.parseStock(responseBody);
            Integer total_sales = Integer.valueOf(cecProductsAPIStockResponse.total_sales);
            
            solds = total_sales;
        }
        return solds;
    } 
        
}