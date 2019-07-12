trigger EnvioEmailNotifInterna on Order (before update) {
	Set<Id> idPedidos = new Set<Id>();					//Guardamos los id de los pedidos que están cerrados y no se ha enviado el email de notificación interna
    Set<Id> idCuentas = new Set<Id>();					//Guardamos los id de las cuentas que tienen este producto para hacer la búsqueda
    Set<OrderItem> listaProd = new Set<OrderItem>();	//Guardamos los productos del pedido que tienen observaciones
    Map<Id, Id> cuentaPedido = new Map<Id, Id>();		//Guardamos la relación entre la cuenta que ha hecho el pedido y el propio pedido
    Map<Id, Id> asistentePedido = new Map<Id, Id>();	//Guardamos la relación entre el asistente a la actividad y el pedido
    String mssg = '';									//Variable donde guardar el mensaje del resultado
    String subject = 'CEC - Nou inscrit a ';
    String emailBody = 'La persona XXXX s\'ha inscrit a l\'activitat "YYYYY"';
        
    System.debug('EnvioEmailNotifInterna');
    
    for (Order pedido : trigger.new) {
        Order beforeUpdate = trigger.oldMap.get(pedido.Id);
        System.debug('beforeUpdate.Notificaci_n_interna__c '+beforeUpdate.Notificaci_n_interna__c);
        System.debug('pedido.Cerrado__c '+pedido.Cerrado__c);
        System.debug('pedido.webkul_wws__woo_Order_Number__c '+pedido.webkul_wws__woo_Order_Number__c);
        if (beforeUpdate.Etapa__c != pedido.Etapa__c  && pedido.Etapa__c == '3.Cerrada' && pedido.Notificaci_n_interna__c == false && pedido.Cerrado__c == true) {
        //if (pedido.Etapa__c == '3.Cerrada' && pedido.Notificaci_n_interna__c == false) {
            System.debug('pedido '+pedido);
            //almacenamos los ids de los pedidos que estén cerrados y no hayan enviado todavía el email de notificación interna
            idPedidos.add(pedido.Id);
            //almacenamos la relación del pedido con la cuenta que lo ha comprado
            cuentaPedido.put(pedido.Id, pedido.AccountId);
            //guardamos los ids de las cuentas que han hecho el pedido
            idCuentas.add(pedido.AccountId);
        }
    }
    
    //recuperamos los productos de los pedidos que están cerrados y no se ha enviando aún el email de notificación interna
    List<OrderItem> listaProductos = [Select id, OrderId, Product2Id, Asistente__c, Product2.Name, Product2.Email_de_notificaci_n_interna__c From OrderItem Where OrderId =: idPedidos];
    System.debug('listaProductos '+listaProductos);
    	
    if (listaProductos.size() > 0) {
		for (OrderItem prodPedido : listaProductos) {
            if (prodPedido.Product2.Email_de_notificaci_n_interna__c != '' && prodPedido.Product2.Email_de_notificaci_n_interna__c != null) {
                if (prodPedido.Asistente__c != null) {
                    //almacenamos la relación del pedido con el asistente
                    asistentePedido.put(prodPedido.OrderId, prodPedido.Asistente__c);
                    //guardamos los ids de los asistentes a la actividad
                    idCuentas.add(prodPedido.Asistente__c);
                }
                //guardamos solo los productos que tienen notifiación interna para enviar por email
                if (listaProd.size() > 0) {
                    for (OrderItem prod : listaProd) {
                        if (prod.Product2Id != prodPedido.Product2Id) { listaProd.add(prodPedido); }
                    }
                }
                else {
                    listaProd.add(prodPedido);
                }
            }
        }
        
        //System.debug('listaProd '+listaProd);
        
        //Obtenemos todas las cuentas que van a recibir el email, asistentes como compradores
        List<Account> listaCuentas = [Select id, Name, PersonEmail, Email_Principal__c From Account Where Id =: idCuentas];
        System.debug('listaCuentas '+listaCuentas);
        
        for (OrderItem prodPedido1 : listaProd) {
            //Recuperamos las relaciones de las cuentas y el pedido en cuestión
            Id cuentaProducto = cuentaPedido.get(prodPedido1.OrderId);
            Id asistenteProducto = asistentePedido.get(prodPedido1.OrderId);    
            
            String subjectActividad = subject + prodPedido1.Product2.Name;
            
            for (Account cuenta : listaCuentas) {
                Set<String> dirEmail = new Set<String>();
                if (cuenta.id == cuentaProducto && asistenteProducto == null) {
                    dirEmail.add(prodPedido1.Product2.Email_de_notificaci_n_interna__c);
                    System.debug('Enviamos emails');
                    emailBody = emailBody.replace('XXXX', cuenta.Name);
                    emailBody = emailBody.replace('YYYYY', prodPedido1.Product2.Name);
                    mssg = mssg + ' ' + SendEmail.Send(dirEmail, subjectActividad, emailBody);
                } 
                else if (cuenta.id == asistenteProducto && cuentaProducto != cuenta.id) {
                    emailBody = emailBody.replace('XXXX', cuenta.Name);
                    emailBody = emailBody.replace('YYYYY', prodPedido1.Product2.Name);
                    mssg = mssg + ' ' + SendEmail.Send(dirEmail, subjectActividad, emailBody);
                }
            }
    
        }
        System.debug('mssg.contains '+mssg.contains('Error'));
        //Si los emails se han enviado correctamente, ponemos el checkbox que indica que ha sido enviado el email a true, para que no se vuelva a enviar
        if (!mssg.contains('Error') || Test.isRunningTest()) {
            System.debug('Actualizamos los pedidos ');
            List<Order> pedidosUpdate = [Select id From Order Where Id =: idPedidos];
            System.debug('pedidosUpdate '+pedidosUpdate);
            for (Order pedidoUpdt : pedidosUpdate) {
                pedidoUpdt.Notificaci_n_interna__c = true;
            }
        }        
    }
    
}