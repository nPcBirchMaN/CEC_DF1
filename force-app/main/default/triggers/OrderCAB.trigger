trigger OrderCAB on Order (after Update) 
{
    
    List<Factura__c> listaFacturas = new List<Factura__c>();                                //Creamos una lista para añadir las facturas que se crean,
    List<L_neas_de_factura__c> listaLineasFactura = new List<L_neas_de_factura__c>();       //una lista para añadir las lineas de factura de cada factura,
    List<OrderItem> listaproductosdelpedido = new list<OrderItem>();                        //una lista con los productos que estan dentro de cada pedido,
    List<Product2> listadeproductos = new List<Product2>();                                 //y una lista para insertar los productos existentes.
    Set<Order> SetIDdeOrder = new Set<Order>();                                             //Ademas, creamos un SET para registrar los pedidos.
    Set<Id> SetIdFacturas = new Set<Id>();
    List<Vencimiento__c> listaVencimientos = new List<Vencimiento__c>();
    Set<Id> CuentasConFacturas = new Set<Id>();
    Set<Id> SetIdCuentas = new Set<Id>();
    Set<Id> vencimientoPedido = new Set<Id>();
    System.debug('Pedido finalizado, generamos factura');
    
    for (Order ord: trigger.new)
    {                                                                                       //Si la etapa del pedido es cerrada                                         
		Order beforeUpdate = Trigger.oldMap.get(ord.id);
        if (ord.Etapa__c == '3.Cerrada' && ord.Cerrado__c == true && beforeUpdate.Etapa__c != ord.Etapa__c){ //el pedido se añade al SET
           SetIDdeOrder.add(ord);
        }
    }
    if (SetIDdeOrder.size() > 0) {                                                          //Entonces, si el SET tiene registros...
        //listadeproductos = [SELECT ID, Name, Tipo_de_producto__c FROM Product2];
        listaproductosdelpedido = [SELECT ID, OrderId, Product2Id, Quantity, OrderItemNumber, UnitPrice, Product2.Name, Product2.Tipo_de_producto__c, Product2.tax_class__c, Product2.tax_status__c,
                                   Product2.Product_type__c, Order.Periodo_recurrente__c, Order.Recurrente__c, Product2.Datos_de_encuentros__c, Product2.Reuni_n_Previa__c
                                   FROM OrderItem WHERE OrderId =: SetIDdeOrder];
        system.debug('Probamos listaproductosdelpedido '+ listaproductosdelpedido);
                                                                                            //Buscamos que productos existen y cuales están dentro del pedido.
           
        for (Order pedido : SetIDdeOrder) {
            Factura__c facturaNueva = new Factura__c ();
            for(OrderItem list1: listaproductosdelpedido){
                if (pedido.Id == list1.OrderId)  {
                    facturaNueva.Name = 'Pedido '+ pedido.OrderNumber;
                    facturaNueva.Cliente__c = pedido.AccountId;
                    facturaNueva.Fecha_emisi_n_factura__c = Date.today();
                    facturaNueva.Tipo_de_pago__c = pedido.Tipo_de_pago__c;
                    facturaNueva.Tipo_de_Factura__c='Definitiva';
                    facturaNueva.Id_de_Pedido__c= pedido.id;
                    if (list1.Product2.Product_type__c == 'subscription') {
                        facturaNueva.Cuota_Socio__c = true;
                    }
                    if (pedido.Tipo_de_Pago__c == 'Tarjeta' || pedido.Tipo_de_pago__c == 'Web') {
                        facturaNueva.Cobrada__c = true;
                        facturaNueva.Estado__c = 'Cobrada';
                        facturaNueva.Fecha_de_pago__c = Date.today();
                        facturaNueva.Fecha_de_cobro__c = Date.today();
                        facturaNueva.Fecha_vencimiento__c = Date.today();
                    } else {
                        facturaNueva.Estado__c = 'Emitida';
                    }
                    //Añadimos la cuenta para mirar si tiene domiciliaciones bancarias anteriores
                    SetIdCuentas.add(pedido.AccountId);
                    
                    listaFacturas.add(facturaNueva);
                    
                    if (pedido.Recurrente__c == true && pedido.Periodo_recurrente__c != '' && pedido.Periodo_recurrente__c != null) {
                        facturaNueva.Name = 'Pedido '+ pedido.OrderNumber+ '/1';
                        for (Integer i=1; i <= Integer.valueOf(pedido.Periodo_recurrente__c); i++) {
                            Date fechaPago = Date.today();
                            fechaPago = fechaPago.addMonths(i);
                            Date fechaFutura = date.newInstance(fechaPago.year(), fechaPago.month(), 1);
                            
                            Factura__c facturaRecurrente = new Factura__c ();
                            facturaRecurrente.Name = 'Pedido '+ pedido.OrderNumber + '/' + (i+1);
                            facturaRecurrente.Cliente__c = pedido.AccountId;
                            facturaRecurrente.Fecha_emisi_n_factura__c = fechaFutura;
                            facturaRecurrente.Tipo_de_pago__c = 'Domiciliación bancaria';
                            facturaRecurrente.Tipo_de_Factura__c='Definitiva';
                            facturaRecurrente.Estado__c = 'Emitida';
                            facturaRecurrente.Id_de_Pedido__c= pedido.id;
                            facturaRecurrente.Fecha_de_pago__c = fechaFutura;
                            listaFacturas.add(facturaRecurrente);
                        }
                    }
                    break;
                }
            }
        }
    }   
    
    if (listaFacturas.size() > 0) {
        //System.debug('SetIdCuentas '+SetIdCuentas);
        //Buscamos si los clientes tienen más facturas domiciliadas
        if (SetIdCuentas.size() > 0) {
            List<Factura__c> facturas = [Select Id, Cliente__c From Factura__c Where Tipo_de_pago__c = 'Domiciliación bancaria' And Cliente__c = : SetIdCuentas];
            for (Factura__c factura : facturas) {
                CuentasConFacturas.add(factura.Cliente__c);
            }
            //System.debug('CuentasConFacturas '+CuentasConFacturas);
        }
        //Insertamos las facturas que hemos creado
        database.insert(listaFacturas);  
      
        for (Factura__c factura: listaFacturas){                                                //A mayores, a cada factura 
            for (OrderItem prod: listaproductosdelpedido) {                                     //según sus productos, se crean sus correspondientes lineas de factura.
                if (factura.Id_de_Pedido__c == prod.OrderId) {
                    L_neas_de_factura__c lineaNueva = new L_neas_de_factura__c ();
                    lineaNueva.Factura__c = factura.Id;
                    lineaNueva.Producto__c = prod.Product2Id;
                    lineaNueva.Cantidad__c = prod.Quantity;
                    lineaNueva.Precio_unitario__c = prod.UnitPrice;
                    //lineaNueva.Observaciones_del_producto__c = prod.Product2.Datos_de_encuentros__c;
                    String observaciones_aux=((prod.Product2.Reuni_n_Previa__c != null)? ('Reunió prèvia: ' + prod.Product2.Reuni_n_Previa__c + '. ') : '') 
                        											+ ((prod.Product2.Datos_de_encuentros__c != null)?('Lloc de trobada: '+ prod.Product2.Datos_de_encuentros__c +'.'): '');
                    lineaNueva.Observaciones_del_producto__c = observaciones_aux.left(254);
                    
					
                    system.debug('lineaNueva'+ lineaNueva);
                    
                    if (prod.Product2.tax_status__c == 'shipping' || prod.Product2.tax_status__c == 'none') {
                    	lineaNueva.Tipo_de_impuesto__c = 'zero';
                    } else if ((prod.Product2.tax_status__c != 'shipping' && prod.Product2.tax_status__c != 'none') && (prod.Product2.tax_class__c == null || prod.Product2.tax_class__c == '')) {
                        lineaNueva.Tipo_de_impuesto__c = 'zero';
                    } else {
                        lineaNueva.Tipo_de_impuesto__c = prod.Product2.tax_class__c;
                    }
                    
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
                                            Fecha_vencimiento__c, Fecha_de_pago__c, Fecha_emisi_n_factura__c, Cliente__r.Id_Cliente__c, Cliente__r.Fecha_alta_original__c, Cliente__r.Categor_a__c,
                                            Cliente__r.CreatedDate, Cliente__c, Cliente__r.IBAN__c, Cliente__r.BIC_SWIFT__c, Id_de_Pedido__c From Factura__c Where Id =: SetIdFacturas];
        //System.debug('facturasCreadas '+facturasCreadas);
    	for(Factura__c factCreada:facturasCreadas ){                                               //se genera un vencimiento automático de dicha factura...
            //System.debug('factCreada '+factCreada);
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
            vencimientoNuevo.BIC_SWIFT__c = factCreada.Cliente__r.BIC_SWIFT__c;
            //System.debug('vencimientoNuevo '+vencimientoNuevo);
            //Añadimos el número de pago 0 si es único, el resto del 1 a N
            String nombreFactura = factCreada.Name;
            if (nombreFactura.lastIndexOf('/') != -1) {
                vencimientoNuevo.N_mero_de_pago__c = Decimal.valueOf(nombreFactura.substringAfterLast('/'));
            } else {
                vencimientoNuevo.N_mero_de_pago__c = 0;
            }
            vencimientoNuevo.Referencia_recibo__c = factCreada.N_mero_de_factura__c + '/' + vencimientoNuevo.N_mero_de_pago__c;
            
            //Añadimos el iban
            String iban = factCreada.Cliente__r.IBAN__c;
            String ibanFormateado = factCreada.Cliente__r.IBAN__c;
            if (iban != null) {
                iban = iban.replaceAll(' ', '');
                if (iban.length() == 24) {
                    ibanFormateado = iban.substring(0, 4) + ' ' + iban.substring(4, 8) + ' ' + iban.substring(8, 12) + ' ' + iban.substring(12, 16) + ' ' + iban.substring(16, 20) + ' ' + iban.substring(20, 24);
                }
            }
            vencimientoNuevo.IBAN__c = ibanFormateado;
            
            
            
            //Si es una domiciliación bancaria
            if (vencimientoNuevo.Tipo_de_Pago__c == 'Domiciliación bancaria' ) {
                //Indicamos si es un residente o no
                if (factCreada.Cliente__r.IBAN__c != null) {
                    vencimientoNuevo.Residente__c = (factCreada.Cliente__r.IBAN__c.containsIgnoreCase('ES') == true)? 'S':'N';
                }
                                
                //Fecha firma mandato es la fecha de alta original o la fecha de creación de la cuenta de no socio
                if (factCreada.Cliente__r.Categor_a__c == 'No_soci' || factCreada.Cliente__r.Categor_a__c == 'Menor No soci' ) {
                    Datetime fechaCreacion = factCreada.Cliente__r.CreatedDate;
                    Date fecha = Date.newInstance(fechaCreacion.year(), fechaCreacion.month(), fechaCreacion.day());
                    vencimientoNuevo.Fecha_firma_mandato__c = fecha;
                } else {
                    vencimientoNuevo.Fecha_firma_mandato__c = factCreada.Cliente__r.Fecha_alta_original__c;
                }
                
                //La referencia del mandato es el Id del cliente con mínimo 8 dígitos, sino, se le añaden 0s hasta conseguirlos
                //Si no es socio, hay que utilizar el Id de Salesforce
                String idCliente = String.valueOf(factCreada.Cliente__r.Id_Cliente__c);
                String refMandato = idCliente;
                if (idCliente != null && idCliente != '') {
                     if (idCliente.length() < 8) {
                        Integer tam = idCliente.length();
                        for (Integer j = tam; j < 9; j++) {
                            refMandato = '0'+refMandato;
                        }
                    }
                } else {
                    refMandato = factCreada.Cliente__c;
                }
                vencimientoNuevo.Referencia_mandato__c = refMandato;
                
                //Si es la primera domiciliación del cliente, hay que ponerle Tipo adeudo FIRST
                if (CuentasConFacturas.size() > 0) {
                    //System.debug('CuentasConFacturas tam '+CuentasConFacturas);
                    Boolean tieneFacturas = false;
                    //Si el cliente está en CuentasConFacturas, es que ya tiene y por tanto se mantiene el Tipo adeudo por defecto que es RCUR
                    for (Id idCuenta : CuentasConFacturas) {
                        if (idCuenta == factCreada.Cliente__c) {
                            tieneFacturas = true;
                        }
                    }
                    //System.debug('tieneFacturas '+tieneFacturas);
                    //Como no tiene facturas, le ponemos FRST
                    if (tieneFacturas == false) {
                        if (vencimientoPedido.size() > 0) {
                            Boolean hayVencimiento = false;
                            for (Id pedido : vencimientoPedido) {
                                if (pedido == factCreada.Id_de_Pedido__c) {
                                    hayVencimiento = true;
                                }
                            } 
                            //System.debug('hayVencimiento '+hayVencimiento);
                            if (hayVencimiento == false) {
                                vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                        		vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                            }
                        } else {
                            //System.debug('No vencimientos ');
                            vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                        	vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                        }
                    }
                }
                else {
                    if (vencimientoPedido.size() > 0) {
                        Boolean hayVencimiento = false;
                        for (Id pedido : vencimientoPedido) {
                            if (pedido == factCreada.Id_de_Pedido__c) {
                                hayVencimiento = true;
                            }
                        } 
                        //System.debug('hayVencimiento '+hayVencimiento);
                        if (hayVencimiento == false) {
                            vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                            vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                        }
                    } else {
                        //System.debug('No vencimientos, no facturas');
                        vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                        vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                    }
                }
                
            } else {
                vencimientoNuevo.Tipo_adeudo__c = null;
            }
            //System.debug('vencimientoNuevo '+vencimientoNuevo);
            listaVencimientos.add(vencimientoNuevo);
        } 
        
        if (listaVencimientos.size() > 0) {
            //System.debug('listaVencimientos '+listaVencimientos);
            database.insert(listaVencimientos);
        }
        
    }
}