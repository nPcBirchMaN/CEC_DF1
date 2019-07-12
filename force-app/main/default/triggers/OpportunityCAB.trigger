trigger OpportunityCAB on Opportunity (after update) 
{
	//Nacho: cuando se cierra la oportunidad se crea una factura
	List<Factura__c> listaFacturas = new List<Factura__c>();                                //Creamos una lista para añadir las facturas que se crean,
    List<L_neas_de_factura__c> listaLineasFactura = new List<L_neas_de_factura__c>();       //una lista para añadir las lineas de factura de cada factura,
    List<OpportunityLineItem> listaproductosOportunidad = new list<OpportunityLineItem>();  //una lista con los productos que estan dentro de cada oportunidad,
    List<Product2> listadeproductos = new List<Product2>();                                 //y una lista para insertar los productos existentes.
    Set<Id> SetIDdeOpty1 = new Set<Id>();                                  //Ademas, creamos un SET para registrar las oportunidades.
    Set<Id> SetIdFacturas = new Set<Id>();
    List<Vencimiento__c> listaVencimientos = new List<Vencimiento__c>();
    Set<Opportunity> SetIDdeOpty = new Set<Opportunity>(); 
    Set<Id> CuentasConFacturas = new Set<Id>();
    Set<Id> SetIdCuentas = new Set<Id>();
    Set<Id> vencimientoPedido = new Set<Id>();
    
    for (Opportunity opt: trigger.new)
    {                                                                                       //Si la etapa del pedido es cerrada                                         
		Opportunity beforeUpdate = Trigger.oldMap.get(opt.id);
        /*if (opt.Etapa__c == '3.Cerrada' && opt.Cerrado__c == true && beforeUpdate.Etapa__c != ord.Etapa__c){ //el pedido se añade al SET
           SetIDdeOrder.add(ord);
        }*/
        if(opt.StageName == 'Cerrado Éxito' && beforeUpdate.StageName != opt.StageName && opt.factura_generada__c==false)
        {
            SetIDdeOpty1.add(opt.id);
            system.debug('came through');
        }
    }
    List<Factura__c> listFactAux = [SELECT Id_de_Oportunidad__c FROM Factura__c where Id_de_Oportunidad__c=:SetIDdeOpty1];
    for (Factura__c fact_aux: listFactAux)
    {
        SetIDdeOpty1.remove(fact_aux.Id_de_Oportunidad__c);
    }
    
    List<Opportunity> aux_opty = [SELECT N_Oportunidad__c,AccountId,Tipo_de_pago__c,id,Nombre_fotograf_a__c,Nombre_exposici_n__c FROM Opportunity where id=:SetIDdeOpty1];
    for (Opportunity opt_final: aux_opty)
    {
        SetIDdeOpty.add(opt_final);
    }
    //Si tenemos oportunidades, leemos todos los productos contenidos en las oportunidades para posteriormente hacer las facturas y sus lineas de factura...
    if(SetIDdeOpty.size()>0)
    {
        listaproductosOportunidad = [SELECT ID, OpportunityId, Product2Id, Quantity, UnitPrice, Product2.Name, Product2.Tipo_de_producto__c, Product2.tax_class__c, Product2.tax_status__c,
                                   Product2.Product_type__c, Product2.Datos_de_encuentros__c, Description FROM OpportunityLineItem WHERE OpportunityId =: SetIDdeOpty];       
        for(Opportunity opty: SetIDdeOpty)
        {
            Factura__c facturaNueva = new Factura__c ();
            for(OpportunityLineItem list1: listaproductosOportunidad)
            {
           		if(opty.id==list1.OpportunityId)
                {
                    facturaNueva.Name = 'Oportunidad '+ opty.N_Oportunidad__c;
                    facturaNueva.Cliente__c = opty.AccountId;
                    facturaNueva.Fecha_emisi_n_factura__c = Date.today();
                    System.debug('tdp :: ' + opty.tipo_de_pago__c);
                    if(opty.tipo_de_pago__c != null && opty.tipo_de_pago__c.equalsIgnoreCase('Domiciliación'))
                   		facturaNueva.Tipo_de_pago__c = 'Domiciliación bancaria';
                    else
                    	facturaNueva.Tipo_de_pago__c = opty.Tipo_de_pago__c;
                    facturaNueva.Tipo_de_Factura__c='Definitiva';
                    facturaNueva.Nombre_fotograf_a__c=opty.Nombre_fotograf_a__c;
                    facturaNueva.Nombre_exposici_n__c=opty.Nombre_exposici_n__c;
                    facturaNueva.Id_de_Oportunidad__c= opty.id;
                    if (list1.Product2.Product_type__c == 'subscription')
                    {
                        facturaNueva.Cuota_Socio__c = true;
                    }
                    if (opty.Tipo_de_Pago__c == 'Tarjeta') 
                    {
                        facturaNueva.Cobrada__c = true;
                        facturaNueva.Estado__c = 'Cobrada';
                        facturaNueva.Fecha_de_pago__c = Date.today();
                        facturaNueva.Fecha_de_cobro__c = Date.today();
                        facturaNueva.Fecha_vencimiento__c = Date.today();
                    }
                    listaFacturas.add(facturaNueva);
                    SetIdCuentas.add(opty.AccountId);
                    break;
                }
            }
        }
    }
    
    if (listaFacturas.size() > 0)
    {    
        System.debug('SetIdCuentas '+SetIdCuentas);
        //Buscamos si los clientes tienen más facturas domiciliadas
        if (SetIdCuentas.size() > 0) {
            List<Factura__c> facturas = [Select Id, Cliente__c From Factura__c Where Tipo_de_pago__c = 'Domiciliación bancaria' And Cliente__c = : SetIdCuentas];
            for (Factura__c factura : facturas) { CuentasConFacturas.add(factura.Cliente__c); }
            System.debug('CuentasConFacturas '+CuentasConFacturas);
        }
        
        database.insert(listaFacturas);  
        for (Factura__c factura: listaFacturas){                                                //A mayores, a cada factura 
            for (OpportunityLineItem prod: listaproductosOportunidad) {                                     //según sus productos, se crean sus correspondientes lineas de factura.
                if (factura.Id_de_Oportunidad__c == prod.OpportunityId) {
                    L_neas_de_factura__c lineaNueva = new L_neas_de_factura__c ();
                    lineaNueva.Factura__c = factura.Id;
                    lineaNueva.Producto__c = prod.Product2Id;
                    lineaNueva.Cantidad__c = prod.Quantity;
                    lineaNueva.Precio_unitario__c = prod.UnitPrice;
                    lineaNueva.Observaciones_del_producto__c = prod.Product2.Datos_de_encuentros__c;
                    lineaNueva.Nombre_alternativo__c = prod.Description;
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
        
        List<Factura__c> facturasCreadas = [Select Id, Name, Id_de_Pedido__c, Fecha_emisi_n_factura__c, N_mero_de_factura__c, Tipo_de_pago__c, Tipo_de_Factura__c, Inicio_periodo_facturaci_n__c, Importe_total_factura__c, Cobrada__c, Impagada__c, 
                                            Fecha_vencimiento__c, Fecha_de_pago__c, Cliente__r.Id_Cliente__c, Cliente__r.Fecha_alta_original__c, Cliente__r.Categor_a__c,
                                            Cliente__r.CreatedDate, Cliente__c, Cliente__r.IBAN__c, Cliente__r.BIC_SWIFT__c From Factura__c Where Id =: SetIdFacturas];
        
    	for(Factura__c factCreada:facturasCreadas ){                                               //se genera un vencimiento automático de dicha factura...
            Vencimiento__c vencimientoNuevo = new Vencimiento__c();
            vencimientoNuevo.N_mero_de_pago__c = 0;
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
            System.debug('vencimientoNuevo Tipo_de_Pago__c :: ' + vencimientoNuevo.Tipo_de_Pago__c);
            System.debug('factCreada.Tipo_de_pago__c; Tipo_de_Pago__c :: ' + factCreada.Tipo_de_pago__c);
            
            if (vencimientoNuevo.Tipo_de_Pago__c == 'Domiciliación bancaria' ) {
                //Indicamos si es un residente o no
                if (factCreada.Cliente__r.IBAN__c != null) {
                    vencimientoNuevo.Residente__c = (factCreada.Cliente__r.IBAN__c.containsIgnoreCase('ES') == true)? 'S':'N';
                }
                
                //Fecha firma mandato es la fecha de alta original o la fecha de creación de la cuenta de no socio
                Datetime fechaCreacion = factCreada.Cliente__r.CreatedDate;
                Date fecha = Date.newInstance(fechaCreacion.year(), fechaCreacion.month(), fechaCreacion.day());
                vencimientoNuevo.Fecha_firma_mandato__c = fecha;

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
                    System.debug('CuentasConFacturas tam '+CuentasConFacturas);
                    Boolean tieneFacturas = false;
                    //Si el cliente está en CuentasConFacturas, es que ya tiene y por tanto se mantiene el Tipo adeudo por defecto que es RCUR
                    for (Id idCuenta : CuentasConFacturas) {
                        if (idCuenta == factCreada.Cliente__c) {
                            tieneFacturas = true;
                        }
                    }
                    System.debug('tieneFacturas '+tieneFacturas);
                    //Como no tiene facturas, le ponemos FRST
                    if (tieneFacturas == false) {
                        if (vencimientoPedido.size() > 0) {
                            Boolean hayVencimiento = false;
                            for (Id pedido : vencimientoPedido) {
                                if (pedido == factCreada.Id_de_Pedido__c) {
                                    hayVencimiento = true;
                                }
                            } 
                            System.debug('hayVencimiento '+hayVencimiento);
                            if (hayVencimiento == false) {
                                vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                                vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                            }
                        } else {
                            System.debug('No vencimientos ');
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
                        System.debug('hayVencimiento '+hayVencimiento);
                        if (hayVencimiento == false) {
                            vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                            vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                        }
                    } else {
                        System.debug('No vencimientos, no facturas');
                        vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                        vencimientoPedido.add(factCreada.Id_de_Pedido__c);
                    }
                }
                
                
                
            } else {
                vencimientoNuevo.Tipo_adeudo__c = null;
            }
            System.debug('vencimientoNuevo '+vencimientoNuevo);
            listaVencimientos.add(vencimientoNuevo);
        } 
        
        if (listaVencimientos.size() > 0) {
            database.insert(listaVencimientos);
        }          
    }
    
    
    
}