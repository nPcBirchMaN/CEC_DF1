trigger PedidoCompletadoEmail on Order (before update) {
	
    Set<Id> idPedidos = new Set<Id>();					//Guardamos los id de los pedidos que están cerrados y no se ha enviado el emial de observaciones
    Set<Id> idCuentas = new Set<Id>();					//Guardamos los id de las cuentas que tienen este producto para hacer la búsqueda
    Set<OrderItem> listaProd = new Set<OrderItem>();	//Guardamos los productos del pedido que tienen observaciones
    Map<Id, Id> cuentaPedido = new Map<Id, Id>();		//Guardamos la relación entre la cuenta que ha hecho el pedido y el propio pedido
    Map<Id, Id> asistentePedido = new Map<Id, Id>();	//Guardamos la relación entre el asistente a la actividad y el pedido
    Set<String> emailList = new Set<String>();
    List<Order> pedidos = new List<Order>();
    String mssg = '';									//Variable donde guardar el mensaje del resultado
    String subject = 'CEC - Confirmació de comanda';
    String emailBody = '';
    String emailOrder = '';
    String emailProdTable = '<div style="margin-left:20px;padding:10px;padding-bottom:10px;"><Table><tr><th style="width:250px;text-align:Left;">CONCEPTE</th><th style="width:100px;'+
        'text-align:center;">QUANTITAT</th><th style="width:100px;text-align:center;">P. UNITARI</th><th style="width:100px;text-align:center;">P. TOTAL</th></tr>';
    String emailProdTableEnd = '</tr></Table></div>';
    String emailEnd = '<br><br><p>Esperem que gaudeixis de la/les activitat/s.</p><p>Salutacions cordials,</p><br>'+
        '<img src="https://cec.cat/wp-content/uploads/2018/07/CEC-Logo.png"alt="CEC-Logo" width="12%" /><p>Paradís, 10 · 08002 Barcelona<br>'+
        'Tel. 933 152 311<br><a href="www.cec.cat">www.cec.cat</a></p>';
    String emailProducts = '';
    String productTotal = '';
    String emailInscripciones = '';
    String dateStr = '';
    String ivaIncluido = 'I.V.A. INCLÒS';
    String exentoIva = Label.LeyExentoIVA;
    Boolean iva = false;
    Boolean exento = false;
    String ivaExento = '';
    
    System.debug('PedidoCompletadoEmail');
    
    for (Order pedido : trigger.new) {
        Order beforeUpdate = trigger.oldMap.get(pedido.Id);
        if ((beforeUpdate.Etapa__c != pedido.Etapa__c || pedido.webkul_wws__woo_Order_Number__c != null) && pedido.Etapa__c == '3.Cerrada' && 
            pedido.Observaciones_enviadas__c == false && pedido.Cerrado__c == true) {
            //almacenamos los ids de los pedidos que estén cerrados y no hayan enviado todavía el email de las observaciones
                idPedidos.add(pedido.Id);
                pedidos.add(pedido);
                //almacenamos la relación del pedido con la cuenta que lo ha comprado
                cuentaPedido.put(pedido.Id, pedido.AccountId);
                //guardamos los ids de las cuentas que han hecho el pedido
                idCuentas.add(pedido.AccountId);
                //ponemos el checkbox que indica que ha sido enviado el email a true, para que no se vuelva a enviar
                pedido.Observaciones_enviadas__c = true;
                
                Date fechaPedido = pedido.EffectiveDate;
                Integer year = fechaPedido.year();
                Integer month = fechaPedido.month();
                Integer day = fechaPedido.day();
                Datetime orderDate = DateTime.newInstance(year, month, day);
                dateStr = orderDate.format('dd/MM/yyyy');
                emailInscripciones = '<br><br>' + dateStr + '<br><br><p>Gràcies per inscriure\'t a la/les següent/s activitat/s.<br><br>';
                emailOrder = '<br><br><br><br>El resum de la comanda <strong>'+pedido.OrderNumber+'</strong> és el següent:</p><br>';
                Decimal totales = pedido.TotalAmount.setScale(2, RoundingMode.CEILING);
                List<String> args = new String[]{'0','number','<span>#,###.0</span>'};
				String totalesFormateado = String.format(totales.format(), args);
                productTotal = '<p style="text-align:left;margin-left:320px">_____________________________________</p><div style="margin-left:390px;"><table ><tr>'+
                    '<td style="width:10px;"></td><th style="width:110px;font-size:16px;padding-top:7px;">TOTAL</th><th style="width:50px;text-align:right;font-size:16px;padding-top:7px;">'+
                    totalesFormateado+'&nbsp;€</th></tr></table>';
    	}
    }
    
    //recuperamos los productos de los pedidos que están cerrados y no se ha enviando aún el email de observaciones
    List<OrderItem> listaProductos = [Select id, OrderId, Product2Id, Asistente__c, Product2.Name, Product2.Observaciones_email__c, Quantity, UnitPrice, TotalPrice, Product2.Fecha_de_fin__c, 
                                      Product2.Fecha_de_inicio__c, Product2.tax_status__c, Product2.tax_class__c, Product2.Product_type__c, Order.AccountId From OrderItem Where OrderId =: idPedidos];
    
    //System.debug('listaProductos '+listaProductos);
    
    for (OrderItem prodPedido : listaProductos) {
        //system.debug('Alpha-prodpedido: ' + prodpedido);
        //Para los productos exentos de iva, añadir en el nombre *
        Boolean isExento = false;
        //guardamos solo los productos que tienen observaciones para enviar por email
        if (listaProd.size() > 0) {
            for (OrderItem prod : listaProd) {
                //system.debug('Alpha-prod: ' + prod);
                if (prod.Product2Id != prodPedido.Product2Id) { 
                    listaProd.add(prodPedido); 
                }
            }
        }
        else {
            listaProd.add(prodPedido);
        }
        if (prodPedido.Product2.tax_status__c == 'none' || (prodPedido.Product2.tax_status__c == 'taxable' && prodPedido.Product2.tax_class__c == 'zero')) {
            exento = true;
            isExento = true;
        }
        if (prodPedido.Product2.tax_status__c == 'shipping' || (prodPedido.Product2.tax_status__c == 'taxable' && prodPedido.Product2.tax_class__c != 'zero')) {
        	iva = true;   
        }
        Decimal precio = prodPedido.UnitPrice.setScale(2, RoundingMode.CEILING);
        Decimal total = prodPedido.TotalPrice.setScale(2, RoundingMode.CEILING);
        List<String> args = new String[]{'0','number','<span>#,###.0</span>'};
        String precioForm = String.format(precio.format(), args);
        String totalForm = String.format(total.format(), args);
        emailProducts = emailProducts +'<tr><td style="width:250px;">'+prodPedido.Product2.Name+ ((isExento == true)?'*':'')+
            '</td><td style="width:100px;text-align:center;">'+Integer.valueOf(prodPedido.Quantity)+'</td>'+
            '<td style="width:100px;text-align:center;">'+precioForm+'</td><td style="width:100px;text-align:center;">'+totalForm+'</td></tr>';
        
        if (prodPedido.Asistente__c != null) {
            //almacenamos la relación del pedido con el asistente
            asistentePedido.put(prodPedido.OrderId, prodPedido.Asistente__c);
            //guardamos los ids de los asistentes a la actividad
            idCuentas.add(prodPedido.Asistente__c);
        }
    }
    for (OrderItem insProdPedido : listaProductos) {
        Date fechaInicio = insProdPedido.Product2.Fecha_de_inicio__c;
        Date fechaFin = insProdPedido.Product2.Fecha_de_fin__c;
        Datetime fechaInicioDate = (fechaInicio != null)? DateTime.newInstance(fechaInicio.year(), fechaInicio.month(), fechaInicio.day()) : null;
        Datetime fechaFinDate = (fechaFin != null)? DateTime.newInstance(fechaFin.year(), fechaFin.month(), fechaFin.day()) : null;
        String inicioString = (fechaInicioDate != null)? fechaInicioDate.format('dd/MM/yyyy') : '';
        String finString = (fechaFinDate != null)? fechaFinDate.format('dd/MM/yyyy') : '';
        
        if (emailInscripciones.contains(insProdPedido.Product2.Name) == false) {
            emailInscripciones = emailInscripciones +'<br><br><strong>Inscrits a l\'activitat '+insProdPedido.Product2.Name+((insProdPedido.Product2.Product_type__c == 'activity' || 
                                                                                                                              insProdPedido.Product2.Product_type__c == 'guide')?
                                                                                                                             (' del dia '+inicioString+((insProdPedido.Product2.Fecha_de_fin__c != null)? 
                                                                                                                                                        ' al '+finString : '')): '')
                +': </strong><br>';
             if (insProdPedido.Asistente__c != null) {
                emailInscripciones = emailInscripciones + '-Nombre'+insProdPedido.Asistente__c;
                
            } else {
                emailInscripciones = emailInscripciones + '-Nombre'+insProdPedido.Order.AccountId;
            }
            if (insProdPedido.Product2.Observaciones_email__c != null) {
                emailInscripciones = emailInscripciones + '<br><br><i>Observacions:</i><br>'+insProdPedido.Product2.Observaciones_email__c;
            }
        } else {
            String textoInicial = emailInscripciones.substringBefore('<strong>Inscrits a l\'activitat '+insProdPedido.Product2.Name+((insProdPedido.Product2.Product_type__c == 'activity' || 
                                                                                                                                      insProdPedido.Product2.Product_type__c == 'guide')?
                                                                                                                                     (' del dia '+inicioString+((insProdPedido.Product2.Fecha_de_fin__c != null)? 
                                                                                                                                                                ' al '+finString : '')): '')
                                                                     +': </strong><br>');
            
            String textoFinal = emailInscripciones.substringAfterLast('<strong>Inscrits a l\'activitat '+insProdPedido.Product2.Name+((insProdPedido.Product2.Product_type__c == 'activity' || 
                                                                                                                                       insProdPedido.Product2.Product_type__c == 'guide')?
                                                                                                                                      (' del dia '+inicioString+((insProdPedido.Product2.Fecha_de_fin__c != null)? 
                                                                                                                                                                 ' al '+finString : '')): '')
                                                                      +': </strong><br>');
            
            String textoInscritos = '';
            
            if (insProdPedido.Asistente__c != null) {
                textoInscritos = '<strong>Inscrits a l\'activitat '+insProdPedido.Product2.Name+((insProdPedido.Product2.Product_type__c == 'activity' || 
                                                                                                  insProdPedido.Product2.Product_type__c == 'guide')?
                                                                                                 (' del dia '+inicioString+((insProdPedido.Product2.Fecha_de_fin__c != null)? 
                                                                                                                            ' al '+finString : '')): '')
                    +': </strong><br>'
                    + '-Nombre'+insProdPedido.Asistente__c + '<br>';
                
            } else {
                textoInscritos = '<strong>Inscrits a l\'activitat '+insProdPedido.Product2.Name+((insProdPedido.Product2.Product_type__c == 'activity' || 
                                                                                                  insProdPedido.Product2.Product_type__c == 'guide')?
                                                                                                 (' del dia '+inicioString+((insProdPedido.Product2.Fecha_de_fin__c != null)? 
                                                                                                                            ' al '+finString : '')): '')
                    +': </strong><br>'
                    + '-Nombre'+insProdPedido.Order.AccountId + '<br>';
            }
            emailInscripciones = textoInicial + textoInscritos + textoFinal;
        }
    }
    
    //System.debug('listaProd '+listaProd);
    
    //Obtenemos todas las cuentas que van a recibir el email, asistentes como compradores
    List<Account> listaCuentas = [Select id, Name, PersonEmail From Account Where Id =: idCuentas];
    
    for (OrderItem prodPedido1 : listaProd) {
        //Recuperamos las relaciones de las cuentas y el pedido en cuestión
        Id cuentaProducto = cuentaPedido.get(prodPedido1.OrderId);
        Id asistenteProducto = asistentePedido.get(prodPedido1.OrderId);    
        
        for (Account cuenta : listaCuentas) {
			if (cuenta.id == cuentaProducto || cuenta.id == asistenteProducto) {
                emailInscripciones = emailInscripciones.replaceAll('Nombre'+cuenta.id, cuenta.Name);
                //recuperamos los emails de las cuentas del pedido
                emailList.add(cuenta.PersonEmail);
            }
        }
    }
    
    if (idPedidos.size()  > 0) {
        //Creamos el mensaje de iva y exentos
        ivaExento = ((iva == true)? ('<table><tr><td style="width:10px;"></td><th style="width:60px;font-size:16px;padding-top:7px;"></th><th style="width:100px;'+
            'text-align:right;font-size:12px;padding-top:7px;">'+ivaIncluido+'</th></tr>' ): '') +'</table></div><br><br>' + ((exento == true)? (exentoIva +'<br>'): '');
        //Creamos el cuerpo del mensaje con todos los textos recuperados
    	emailBody = emailInscripciones + emailOrder + emailProdTable + emailProducts + emailProdTableEnd + productTotal + ivaExento + emailEnd;
        //Enviamos el email al comprador
        if(emailList.size()>0)
        {
            mssg = SendEmail.SendHTML(emailList, subject, emailBody);
        }
        else
        {
            emailList.add('atenciosoci@cec.cat');
            //mssg = SendEmail.SendHTML(emailList, 'Confirmació de comanda - Error al enviar email al comprador', emailBody);
        }
    	
    }
    system.debug('mssg ' +mssg);
}