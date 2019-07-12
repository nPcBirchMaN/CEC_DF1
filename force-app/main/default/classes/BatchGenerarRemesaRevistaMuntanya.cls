global class BatchGenerarRemesaRevistaMuntanya implements Database.Batchable<sObject>, Database.AllowsCallouts {
    private String revistaName;
    
    public BatchGenerarRemesaRevistaMuntanya(String NombreRevista) {
        revistaName = NombreRevista;
    }
    
	global List<Account> start (Database.BatchableContext bc) {
        
        Date hoy = Date.today();
        Date fechaRenovacionSuscripcion = hoy.addMonths(1);
        
        System.debug('fechaRenovacionSuscripcion '+fechaRenovacionSuscripcion);
        //Obtenemos todas las cuentas que tengan como fecha de renovación de suspcripción dentro de un mes
        List<Account> returnList = [Select Id, Name, RecordType.Name, Numero_Ejemplares__c, Pagador_Revista_Monta_a__c From Account Where Pagador_Revista_Monta_a__c = true];
        System.debug('returnList '+returnList.size());
        return  returnList;
    }
    global void execute (Database.BatchableContext bc, List<Account> listaCuentas){
        //Creamos un mapa para asignar el nombre del mes dependiendo del número de mes que sea
        Map<Integer,String> meses = new Map<Integer,String>();
        meses.put(1, 'Gener');
        meses.put(2, 'Febrer');
        meses.put(3, 'Març');
        meses.put(4, 'Abril');
        meses.put(5, 'Maig');
        meses.put(6, 'Juny');
        meses.put(7, 'Juliol');
        meses.put(8, 'Agost');
        meses.put(9, 'Setembre');
        meses.put(10, 'Octubre');
        meses.put(11, 'Novembre');
        meses.put(12, 'Desembre');
        
        List<Vencimiento__c> listaVencimientos = new List<Vencimiento__c>();
        List<Factura__c> listaFacturas = new List<Factura__c>();
        List<L_neas_de_factura__c> listaLineasFactura = new List<L_neas_de_factura__c>();
        Set<Id> SetIdFacturas = new Set<Id>();
        Set<Id> CuentasConFacturas = new Set<Id>();
        Set<Id> IdCuentas = new Set<Id>();
        for(Account acc: listaCuentas) { 
        	IdCuentas.add(acc.Id);
        }
        if (IdCuentas.size() > 0) {
            List<Factura__c> facturas = productSuscriptionList.getCuentasConFacturasDomiciliadas(IdCuentas);
            for (Factura__c factura : facturas) {
                CuentasConFacturas.add(factura.Cliente__c);
            }
        }
        
        //Obtenemos el producto revista montaña para crear las facturas
        Product2 productoRevista = productSuscriptionList.getRevista(revistaName);
        
        // Recorremos todas las cuentas para crear una factura por cada una de ellas
        for(Account acc: listaCuentas) {
            //Creamos la factura
            Factura__c nuevaFactura = new Factura__c();
            String nombreFactura_aux=revistaName + ' ' + acc.Name;
            //nuevaFactura.Name = revistaName + ' ' + acc.Name;
            nuevaFactura.Name = nombreFactura_aux.left(79);
            nuevaFactura.Cliente__c = acc.Id;
            nuevaFactura.Fecha_emisi_n_factura__c = Date.today();
            nuevaFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
            nuevaFactura.Tipo_de_Factura__c='Definitiva';
            nuevaFactura.Estado__c = 'Emitida';
            nuevaFactura.Remesa__c = meses.get(Date.today().month());
            nuevaFactura.Ejercicio__c = Date.today().year();
            nuevaFactura.Periodo_de_pago__c = '1';
            
            System.debug('nuevaFactura.Remesa__c '+nuevaFactura.Remesa__c);
            //guardamos la nueva factura en el listado para insertalas todas de una vez
            listaFacturas.add(nuevaFactura);
        }
        
		System.debug('CrearCuotasBatch listaCuentas :: ' + listaCuentas);
  		 if (listaFacturas.size() > 0) {                                                         
            system.debug('Insert: '+listaFacturas);
            //Insertamos la lista de facturas
            database.insert(listaFacturas);
            
            //Creamos una línea de factura por cada factura que se haya creado
            for(Account acc: listaCuentas) {
                for (Factura__c factura: listaFacturas){
                    if (factura.Cliente__c == acc.Id) {
                        L_neas_de_factura__c lineaRevista = new L_neas_de_factura__c ();
                        lineaRevista.Factura__c = factura.Id;
                        lineaRevista.Producto__c = productoRevista.Id;
                        lineaRevista.Cantidad__c = Integer.valueOf(acc.Numero_Ejemplares__c);
                        //Asignamos los impuestos
                        if (productoRevista.tax_status__c == 'shipping' || productoRevista.tax_status__c == 'none') {
                            lineaRevista.Tipo_de_impuesto__c = 'zero';
                        } else if ((productoRevista.tax_status__c != 'shipping' && productoRevista.tax_status__c != 'none') && (productoRevista.tax_class__c == null || productoRevista.tax_class__c == '')) {
                            lineaRevista.Tipo_de_impuesto__c = 'zero';
                        } else {
                            lineaRevista.Tipo_de_impuesto__c = productoRevista.tax_class__c;
                        }
                        
                        for (PricebookEntry precioRevista : productoRevista.PricebookEntries) {
                           lineaRevista.Precio_unitario__c = precioRevista.UnitPrice;
                        }
                        listaLineasFactura.add(lineaRevista);
                        
                        //Almacenamos el id de las facturas para buscarlas a continuación
                        SetIdFacturas.add(factura.Id);
                    }
                }
            }
            if (listaLineasFactura.size() > 0) {
                system.debug('listaLineasFactura' + listaLineasFactura);
                //Insertamos las líneas de facturas
                database.insert(listaLineasFactura);
            } 
         
       	}
        //Comprobamos que se hayan creado las facturas y creamos los vencimientos que les corresponden
        if (SetIdFacturas.size() > 0){
            //Obtenemos los datos de las facturas creadas
            List<Factura__c> facturasCreadas = productSuscriptionList.getFacturasCreadas(SetIdFacturas);
            
            //Por cada factura creamos un vencimiento, salvo las que tienen periodo de pago distinto de 1, que se crearán el número de vencimientos igual al de periodo de pago
            for(Factura__c factCreada:facturasCreadas ){
                for (Integer i = 1; i <= Integer.valueOf(factCreada.Periodo_de_pago__c); i++) {
                    Vencimiento__c vencimientoNuevo = new Vencimiento__c();
                    vencimientoNuevo.Factura__c = factCreada.Id;
                    vencimientoNuevo.Nombre_de_la_factura__c = factCreada.Name;
                    vencimientoNuevo.N_mero_de_Factura__c = factCreada.N_mero_de_factura__c;
                    vencimientoNuevo.Tipo_de_factura__c = factCreada.Tipo_de_Factura__c;
                    vencimientoNuevo.Tipo_de_Pago__c = factCreada.Tipo_de_pago__c;
                    vencimientoNuevo.Importe_de_factura__c = factCreada.Importe_total_factura__c;
                    vencimientoNuevo.Cobrada__c = factCreada.Cobrada__c;
                    vencimientoNuevo.Impagada__c = factCreada.Impagada__c;
                    vencimientoNuevo.N_mero_de_pago__c = (Integer.valueOf(factCreada.Periodo_de_pago__c) == 1)? 0: i;
                    vencimientoNuevo.Fecha_firma_mandato__c = factCreada.Cliente__r.Fecha_alta_original__c;
                    vencimientoNuevo.BIC_SWIFT__c = factCreada.Cliente__r.BIC_SWIFT__c;
                    vencimientoNuevo.Referencia_recibo__c = factCreada.N_mero_de_factura__c + '/' + vencimientoNuevo.N_mero_de_pago__c;
                    
                    String iban = factCreada.Cliente__r.IBAN__c;
                    String ibanFormateado = factCreada.Cliente__r.IBAN__c;
                    if (iban != null) {
                         iban = iban.replaceAll(' ', '');
                        if (iban.length() == 24) {
                            ibanFormateado = iban.substring(0, 4) + ' ' + iban.substring(4, 8) + ' ' + iban.substring(8, 12) + ' ' + iban.substring(12, 16) + ' ' + iban.substring(16, 20) + ' ' + iban.substring(20, 24);
                        }
                        vencimientoNuevo.Residente__c = (factCreada.Cliente__r.IBAN__c.containsIgnoreCase('ES') == true)? 'S':'N';
                    }
                   	vencimientoNuevo.IBAN__c = ibanFormateado;
                    
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
                    
                    
                    //El importe de la factura estará determinado por el número de fracciones: Total / Fracciones
                    vencimientoNuevo.Importe_Total__c = factCreada.Importe_total_factura__c/Decimal.valueOf(factCreada.Periodo_de_pago__c);
                    
                    //Calculamos las fechas de emisión de cada vencimiento
                    date FechaVenc = factCreada.Fecha_emisi_n_factura__c;
                    if (i < Integer.valueOf(factCreada.Periodo_de_pago__c)) {
                        date FechaProxVenc = FechaVenc.toStartOfMonth();
                        Integer NumMeses = 12/Integer.valueOf(factCreada.Periodo_de_pago__c);
                        Integer NC = NumMeses * i;
                        date fechaEmision = FechaProxVenc.addMonths(NC);
                        vencimientoNuevo.Fecha_de_pago__c= fechaEmision;
                        vencimientoNuevo.Inicio_de_Facturaci_n__c = fechaEmision;
                        vencimientoNuevo.Fin_de_Facturaci_n__c = fechaEmision;
                        vencimientoNuevo.Remesa__c = meses.get(NC);
                        vencimientoNuevo.Ejercicio__c = fechaEmision.year();
                    }
                 	else {
                        //Si es la primera domiciliación del cliente, hay que ponerle Tipo adeudo FIRST
                        if (CuentasConFacturas.size() > 0) {
                            Boolean tieneFacturas = false;
                            //Si el cliente está en CuentasConFacturas, es que ya tiene y por tanto se mantiene el Tipo adeudo por defecto que es RCUR
                            for (Id idCuenta : CuentasConFacturas) {
                                if (idCuenta == factCreada.Cliente__c) {
                                    tieneFacturas = true;
                                }
                            }
                            //Como no tiene facturas, le ponemos FRST
                            if (tieneFacturas == false) {
                                vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                            }
                        } else {
                            vencimientoNuevo.Tipo_adeudo__c = 'FRST';
                        }
                        
                        vencimientoNuevo.Inicio_de_Facturaci_n__c = FechaVenc;
                        vencimientoNuevo.Fin_de_Facturaci_n__c = FechaVenc;
                        vencimientoNuevo.Remesa__c = meses.get(FechaVenc.month());
                        vencimientoNuevo.Ejercicio__c = FechaVenc.year();
                    }
                    System.debug('vencimientoNuevo '+vencimientoNuevo);
                    //Guardamos en una lista los vencimientos creados
                    listaVencimientos.add(vencimientoNuevo);
                }  
            } 
            //Insertamos la lista de vencimientos
            if (listaVencimientos.size() > 0) {
                database.insert(listaVencimientos);
                System.debug('listaVencimientos '+listaVencimientos);
            }
        }
    }
    
    global void finish (Database.BatchableContext bc){
        
    }  
}