trigger suscripcionWooCommerce on Order (after update) {
    Set<Id> orderId 	= new Set<Id>(); 							//Set para buscar las líneas de pedidos
    Set<Id> accountId = new Set<Id>(); 								//Set para buscar las cuentas asociadas a los pedidos
    Map<Id, String> accountSuscription = new Map<Id, String>(); 	//Mapa que almacena la relación cuenta - categoría nueva
    Map<Id, String> accountModalidad = new Map<Id, String>(); 		//Mapa que almacena la relación cuenta - modalidad nueva
    Map<Id, Id> orderAccount = new Map<Id, Id>(); 					//Mapa que relaciona pedido - cuenta que hace el pedido
    List <Account> usrNewCategory = new List <Account>();			//Lista que contiene las cuentas a actualizar la categoría
    List <Account> usrNewModalidad = new List <Account>();			//Lista que contiene las cuentas a actualizar la modalidad
    
    for (Order ord: trigger.new)
    {
        Order beforeUpdate = Trigger.oldMap.get(ord.id);
        
        if (beforeUpdate.Etapa__c != ord.Etapa__c && ord.Etapa__c=='3.Cerrada' && ord.Cerrado__c == true)        
        {
            //Guardamos en un Set los id de los pedidos que se han finalizado
            orderId.add(ord.Id);
            //Almacenamos en un map la relación del pedido con su cuenta asociada
            orderAccount.put(ord.Id, ord.AccountId);
        }
    }
    
    //System.debug('orderAccount '+orderAccount);
    //System.debug('orderId '+orderId);
    if (orderId.size() > 0) {
        //System.debug('Got here');
        //Recuperamos las líneas de pedido de todos los pedidos que se han finalizado y sean de tipo suscripción
        List<OrderItem> lineasPedido = [Select Id,Product2.Product_type__c, Product2.Role_to_assign__c, Product2.Name, Product2.Modalidad_a_asignar__c, OrderId, Product2Id, Quantity 
                                        From OrderItem Where Product2.Product_type__c = 'subscription' And OrderId = : orderId];
        System.debug('lineasPedido '+lineasPedido);
        
        for (OrderItem linPedido : lineasPedido) {
            System.debug('Producto :: ' + linPedido.Product2.Name);
            System.debug('Modalidad a asignar: '+linPedido.Product2.Modalidad_a_asignar__c);
            //Guardamos en un set el id de la cuenta asociada al pedido que tiene un producto de tipo suscripción para posteriormente buscar los datos del cliente
            accountId.add(orderAccount.get(linPedido.OrderId));
            //Guardamos en el map accountSuscription la nueva categoría asociada a la cuenta que ha hecho el pedido
            if (linPedido.Product2.Role_to_assign__c == 'soci_participatiu') 
            {
                //Se ha comprado una suscripción de socio participativo
                accountSuscription.put(orderAccount.get(linPedido.OrderId), 'Participatiu');
            } 
            else if (linPedido.Product2.Role_to_assign__c == 'soci') 
            {
                //Se ha comprado una suscripción de socio de pleno derecho
                accountSuscription.put(orderAccount.get(linPedido.OrderId), 'Ple_dret');
            }
            else if (linPedido.Product2.Role_to_assign__c == 'Menor') 
            {
                //Se ha comprado una suscripción de socio de menor
                accountSuscription.put(orderAccount.get(linPedido.OrderId), 'Menor');
            }
            //Guardamos en el map accountModalidad la nueva modalidad asociada a la cuenta que ha hecho el pedido
            if (linPedido.Product2.Modalidad_a_asignar__c != null && linPedido.Product2.Modalidad_a_asignar__c != '')
            	accountModalidad.put(orderAccount.get(linPedido.OrderId), linPedido.Product2.Modalidad_a_asignar__c);
        }
        if (accountId.size() > 0) {
            List<Account> cuentas = [Select Id, Categor_a__c, Modalidad__c From Account Where Id = : accountId];
            //System.debug('accountSuscription '+accountSuscription);
            //System.debug('accountId '+accountId);
            if (accountSuscription.size() > 0 || accountModalidad.size() > 0) {
                //Buscamos las cuentas a las que hay que modificarles la categoría o modalidad
                for (Account usuario : cuentas) {
                    //Asignamos a la cuenta la nueva categoría que hemos almacenado previamente en el map accountSuscription
                    if (accountSuscription.size() > 0) {
                         usuario.Categor_a__c = accountSuscription.get(usuario.Id);
                    }
                    //Asignamos a la cuenta la nueva modalidad que hemos almacenado previamente en el map accountModalidad
                   	if (accountModalidad.size() > 0) {
                         usuario.Modalidad__c = accountModalidad.get(usuario.Id);
                    }
                    //Generamos la fecha de renovación de la suscripción
                    Date today = Date.today();
                    Integer year = today.year();
                    Date fechaFutura = date.newInstance(year+1, today.month(), today.day());
                    usuario.Fecha_renovaci_n_suscripci_n__c = fechaFutura;
                    usrNewCategory.add(usuario);
                }
            }
            //System.debug('usrNewCategory '+usrNewCategory);
            if (usrNewCategory.size() > 0) {
                database.Update (usrNewCategory);
                //Este update provoca que se lance el trigger de cuentas 'onChangeAccount_WS'
            }
        }
    }
}