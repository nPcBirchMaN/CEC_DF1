global class CrearCuotasBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
  
    global List<Account> start (Database.BatchableContext bc) {
        
        Date hoy = Date.today();
        Date fechaRenovacionSuscripcion = hoy.addMonths(1);
        
        System.debug('fechaRenovacionSuscripcion '+fechaRenovacionSuscripcion);
        //Obtenemos todas las cuentas que tengan como fecha de renovación de suspcripción dentro de un mes
        List<Account> returnList = [SELECT Id, Categor_a__c, Modalidad__c, Fecha_aplicaci_n_de_baja__c, Futura_categor_a_s_cio__c, 
                                    Futura_modalidad_del_socio__c, Promociones__c, Promociones__r.Desccuento__c, Promociones__r.Name, 
                                    Fecha_de_Caducidad__c, Fecha_renovaci_n_suscripci_n__c, FirstName, LastName, Periodo_de_pago__c 
                                    FROM Account WHERE Fecha_renovaci_n_suscripci_n__c = : fechaRenovacionSuscripcion];
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
        //
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
        //
        List<Vencimiento__c> listaVencimientos = new List<Vencimiento__c>();
        List<Factura__c> listaFacturas = new List<Factura__c>();
        List<L_neas_de_factura__c> listaLineasFactura = new List<L_neas_de_factura__c>();
        Boolean aplicarFutura = false;
        Boolean promocionNoFinalizada = false;
		Product2 prod = new Product2();
        String modalidad = '';
        String categoria = '';
        Decimal descuento;
        Set<Id> SetIdFacturas = new Set<Id>();
                
        //Creamos la nueva fecha de renovación de suscripción que será la de este año más 1 año
        Date hoy = Date.today();
        Date fechaRenovacionSuscripcion = hoy.addMonths(1);
        fechaRenovacionSuscripcion = fechaRenovacionSuscripcion.addYears(1);
        System.debug('Nueva fechaRenovacionSuscripcion '+fechaRenovacionSuscripcion);
       	
        //Obtenemos la relación del producto con la modalidad del cliente, para crear la factura con el producto que corresponde
        Map<String, Product2> productoModalidad = productSuscriptionList.getProductoModalidad();
        //Obtenemos el producto suplemento para añadirselo a las facturas que tengan pagos fraccionados
        Product2 productoSuplemento = productSuscriptionList.getSuplemento();
        
        // Recorremos todas las cuentas para crear una factura por cada una de ellas
        for(Account acc: listaCuentas) {
            //Comprobamos si hay que aplicarle promoción o ya se ha caducado
            if (acc.Promociones__c != null && acc.Fecha_de_Caducidad__c != null && acc.Fecha_de_Caducidad__c > acc.Fecha_renovaci_n_suscripci_n__c) {
                promocionNoFinalizada = true;
            } else {
                promocionNoFinalizada = false;
            }
            
            //Creamos la factura
            Factura__c nuevaFactura = new Factura__c();
            nuevaFactura.Name = 'Cuota '+ acc.FirstName + ' ' + acc.LastName + ' ' + acc.Fecha_renovaci_n_suscripci_n__c.year();
            nuevaFactura.Cliente__c = acc.Id;
            nuevaFactura.Fecha_emisi_n_factura__c = hoy.addMonths(1);
            nuevaFactura.Fecha_emisi_n_factura__c = nuevaFactura.Fecha_emisi_n_factura__c.addDays(1);
            nuevaFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
            nuevaFactura.Tipo_de_Factura__c='Definitiva';
            nuevaFactura.Cuota_Socio__c = true;
            nuevaFactura.Estado__c = 'Emitida';
            nuevaFactura.Remesa__c = meses.get(acc.Fecha_renovaci_n_suscripci_n__c.month());
            nuevaFactura.Ejercicio__c = acc.Fecha_renovaci_n_suscripci_n__c.year();
            
            //Recuperamos de la cuenta el periodo de pago de las cuotas para crear el número de vencimientos de acuerdo con éste
            if (acc.Periodo_de_pago__c == 'Trimestral') {
                nuevaFactura.Periodo_de_pago__c = '4';
            }else if (acc.Periodo_de_pago__c == 'Anual' || acc.Periodo_de_pago__c == null || acc.Periodo_de_pago__c == '') {
                nuevaFactura.Periodo_de_pago__c = '1';
            } else {
                nuevaFactura.Periodo_de_pago__c = acc.Periodo_de_pago__c;
            }
            System.debug('nuevaFactura.Remesa__c '+nuevaFactura.Remesa__c);
            //Si hay que aplicarle un descuento a la factura, lo indicamos en las observaciones de ésta
            nuevaFactura.obs__c = (promocionNoFinalizada == true)? (acc.Promociones__r.Name + ' - ' +acc.Promociones__r.Desccuento__c +'%') : '';
            
            //guardamos la nueva factura en el listado para insertalas todas de una vez
            listaFacturas.add(nuevaFactura);    
                
            //Cambiamos la fecha de renovación del año con el valor del año siguiente
            acc.Fecha_renovaci_n_suscripci_n__c = fechaRenovacionSuscripcion;
        }
        
		System.debug('CrearCuotasBatch listaCuentas :: ' + listaCuentas);
  
        if (listaFacturas.size() > 0) {                                                         
            system.debug('Insert: '+listaFacturas);
            //Insertamos la lista de facturas
            database.insert(listaFacturas);
            
            //Creamos una línea de factura por cada factura que se haya creado
            for(Account acc: listaCuentas) {
                //Comprobamos si hay que aplicarle promoción o ya se ha caducado
                Integer InicialRenoYear = acc.Fecha_renovaci_n_suscripci_n__c.year();
                Date fechaInicialRenovacion = Date.newInstance(InicialRenoYear - 1, acc.Fecha_renovaci_n_suscripci_n__c.month(), acc.Fecha_renovaci_n_suscripci_n__c.day());
                if (acc.Promociones__c != null && acc.Fecha_de_Caducidad__c != null && acc.Fecha_de_Caducidad__c > fechaInicialRenovacion) {
                    promocionNoFinalizada = true;
                } else {
                    promocionNoFinalizada = false;
                }
                for (Factura__c factura: listaFacturas){
                    if (factura.Cliente__c == acc.Id) {
                        System.debug('promocionNoFinalizada '+promocionNoFinalizada);
                        //Comprobamos si hay que aplicarle la nueva categoría/modalidad o mantiene la que tiene
                        if (acc.Fecha_aplicaci_n_de_baja__c != null && acc.Fecha_aplicaci_n_de_baja__c < fechaInicialRenovacion) {
                            aplicarFutura = true;
                        } else {
                            aplicarFutura = false;
                        }
                        //Obtenemos la categoría y la modalidad que hay que aplicar en la cuota
                        if (aplicarFutura == true) {
                            modalidad = (acc.Futura_modalidad_del_socio__c != null)? acc.Futura_modalidad_del_socio__c : 'soci_participatiu';
                            categoria = (acc.Futura_categor_a_s_cio__c != null)?acc.Futura_categor_a_s_cio__c : acc.Categor_a__c;
                        } else {
                            modalidad = (acc.Modalidad__c != null)? acc.Modalidad__c : 'soci_participatiu';
                            categoria = acc.Categor_a__c;
                        }
                        
                        //Recuperamos el producto que va asociado a la modalidad de la cuenta
                        prod = productoModalidad.get(modalidad);
                        System.debug('Producto '+prod);
                        
                        //Creamos la línea de factura que tendrá el producto obtenido con anterioridad
                        L_neas_de_factura__c lineaNueva = new L_neas_de_factura__c ();
                        lineaNueva.Factura__c = factura.Id;
                        lineaNueva.Producto__c = prod.Id;
                        lineaNueva.Cantidad__c = 1;
                        
                        //Obtenemos el descuento a aplicar en caso de ser necesario
                        if (promocionNoFinalizada == true) {
                            descuento = (100 - acc.Promociones__r.Desccuento__c)/100;
                        } else {
                            descuento = 1;
                        }
                        System.debug('descuento ' +descuento);
                        
                        //Obtenemos el precio a aplicar dependiendo de la categoría del socio y el descuento
                        for (PricebookEntry precios : prod.PricebookEntries) {
                            if ((categoria == 'Ple_dret' || categoria == 'Menor') && precios.Pricebook2.Name == 'Socios') {
                                lineaNueva.Precio_unitario__c = precios.UnitPrice * descuento;
                            } else if (categoria == 'Participatiu' && precios.Pricebook2.Name == 'Socio participativo') {
                                lineaNueva.Precio_unitario__c = precios.UnitPrice * descuento;
                            }  
                        }
                        
                        //Asignamos los impuestos
                        if (prod.tax_status__c == 'shipping' || prod.tax_status__c == 'none') {
                            lineaNueva.Tipo_de_impuesto__c = 'zero';
                        } else if ((prod.tax_status__c != 'shipping' && prod.tax_status__c != 'none') && (prod.tax_class__c == null || prod.tax_class__c == '')) {
                            lineaNueva.Tipo_de_impuesto__c = 'zero';
                        } else {
                            lineaNueva.Tipo_de_impuesto__c = prod.tax_class__c;
                        }
                       	//Guardamos la línea de factura en la lista para insertar todas de una vez
                        listaLineasFactura.add(lineaNueva);
                        
                        //Añadimos Suplemento cuando sean pagos fraccionados
                        if (Integer.valueOf(factura.Periodo_de_pago__c) > 1) {
                            L_neas_de_factura__c lineaSuplemento = new L_neas_de_factura__c ();
                        	lineaSuplemento.Factura__c = factura.Id;
                            lineaSuplemento.Producto__c = productoSuplemento.Id;
                            lineaSuplemento.Cantidad__c = Integer.valueOf(factura.Periodo_de_pago__c);
                            lineaSuplemento.Tipo_de_impuesto__c = 'zero';
                            lineaSuplemento.Descripci_n_del_producto__c = 'Suplemento por fraccionamiento';
                            
                            for (PricebookEntry precioSuplemento : productoSuplemento.PricebookEntries) {
                                if ((categoria == 'Ple_dret' || categoria == 'Menor') && precioSuplemento.Pricebook2.Name == 'Socios') {
                                    lineaSuplemento.Precio_unitario__c = precioSuplemento.UnitPrice;
                                } else if (categoria == 'Participatiu' && precioSuplemento.Pricebook2.Name == 'Socio participativo') {
                                    lineaSuplemento.Precio_unitario__c = precioSuplemento.UnitPrice;
                                 } 
                            }
                            listaLineasFactura.add(lineaSuplemento);
                        }
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
                    System.debug('i '+i);
                    System.debug('Periodo_de_pago__c '+Integer.valueOf(factCreada.Periodo_de_pago__c));
                    if (i <= Integer.valueOf(factCreada.Periodo_de_pago__c)) { //añadimos el igual para que también trate el último vencimiento y no le ponga la fecha de emisión de la factura
                        date FechaProxVenc = FechaVenc.toStartOfMonth();
                        Integer NumMeses = 12/Integer.valueOf(factCreada.Periodo_de_pago__c);
                        Integer NC = NumMeses * (i-1);
                        if (NC <> 0){ //Para segundo y posteriores vencimientos
                            date fechaEmision = FechaProxVenc.addMonths(NC);
                            System.debug('NC '+NC);
                            System.debug('fechaEmision '+fechaEmision);
                            vencimientoNuevo.Fecha_de_pago__c= fechaEmision;
                            vencimientoNuevo.Inicio_de_Facturaci_n__c = fechaEmision;
                            vencimientoNuevo.Fin_de_Facturaci_n__c = fechaEmision;
                            vencimientoNuevo.Remesa__c = meses.get(NC);
                            vencimientoNuevo.Ejercicio__c = fechaEmision.year();                            
                        }
                        else{//Para que el primer vencimiento tenga la fecha de emision de la factura
                            vencimientoNuevo.Inicio_de_Facturaci_n__c = FechaVenc;
                            vencimientoNuevo.Fin_de_Facturaci_n__c = FechaVenc;
                            vencimientoNuevo.Remesa__c = meses.get(FechaVenc.month());
                            vencimientoNuevo.Ejercicio__c = FechaVenc.year();
                        }

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
            }
        }
        
        if (listaCuentas.size() >0) {
            Database.update(listaCuentas);
        }
 
    }
    
    global void finish (Database.BatchableContext bc){
        
    }      
    
}