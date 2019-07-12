global class VencimientoController{
    
    @AuraEnabled
    webservice static String createVencimientos (String FactId, Integer numCuotas){
        system.debug('numCuotas'+ numCuotas);
        system.debug('FactID' + FactId );
        Set<Id> CuentasConFacturas = new Set<Id>();
        Set<Id> vencimientoPedido = new Set<Id>();
        Integer nf = numCuotas;
        
        //Esta es la Query que busca la info de la factura a la que se asociaran los vencimientos.
        Factura__c Fact1 = [SELECT ID, N_mero_de_factura__c, Name, Tipo__c, Importe_total_factura__c, Fecha_emisi_n_factura__c, Fin_periodo_facturaci_n__c, 
                            Tipo_de_pago__c, Tipo_de_Factura__c, Fecha_de_pago__c, Cliente__r.Id_Cliente__c, Cliente__r.Fecha_alta_original__c,
                            Cliente__r.CreatedDate, Cliente__c, Cliente__r.IBAN__c, Cliente__r.BIC_SWIFT__c, Cliente__r.Tipo_cuenta__c, Cliente__r.Categor_a__c,
                            Id_de_Pedido__c, Id_de_Oportunidad__c
                            FROM Factura__c 
                            WHERE Id =: FactId];
        
        //Esta es la Query que comprueba si esa factura tiene vencimientos anteriores.
        List<Vencimiento__c> registroVencimientos = [SELECT Id, Name 
                                                     FROM Vencimiento__c 
                                                     WHERE Factura__c =: FactId]; 
        
        //Se deletean los vencimientos anteriores para recalcular nuevos vencimientos automaticamente.
        database.delete(registroVencimientos);
        
        //Se crea una lista para almacenar los vencimientos y que no pete SF.
        List<Vencimiento__c> listaVencimientos = new List<Vencimiento__c>();
        
       
        //Buscamos si el cliente tiene más facturas domiciliadas
     	Integer facturasDom = [Select COUNT() From Factura__c Where Tipo_de_pago__c = 'Domiciliación bancaria' And Cliente__c = : Fact1.Cliente__c];
        System.debug('facturasDom :: ' + facturasDom); 
        System.debug('Fact1.Tipo_de_pago__c :: ' + Fact1.Tipo_de_pago__c);
        
        if ((Fact1.Tipo_de_pago__c == 'Domiciliación bancaria' && facturasDom > 1) || (Fact1.Tipo_de_pago__c != 'Domiciliación bancaria' && facturasDom > 0)){
            CuentasConFacturas.add(Fact1.Cliente__c);
        }
        
        //System.debug('CuentasConFacturas '+CuentasConFacturas);

        
        for (integer i=0; i< nf; i++){
            Integer numPago = i + 1;
            Vencimiento__c Venc1 = new Vencimiento__c ();    
            Venc1.Factura__c= FactId; 
            Venc1.N_mero_de_Factura__c= Fact1.N_mero_de_factura__c;
            Venc1.N_mero_de_pago__c=  (nf == 1)? 0: numPago;
            Venc1.Nombre_de_la_factura__c= Fact1.Name;
            Venc1.Tipo_de_Factura__c= Fact1.Tipo_de_Factura__c;
            Venc1.Importe_de_factura__c = Fact1.Importe_total_factura__c;
            Venc1.Importe_Total__c= Fact1.Importe_total_factura__c / numCuotas;
            Venc1.Inicio_de_Facturaci_n__c= Fact1.Fecha_emisi_n_factura__c;
            if (nf<=1 && (Fact1.Tipo_de_pago__c == 'Tarjeta' || Fact1.Tipo_de_pago__c == 'Web')){
                Venc1.Fecha_de_pago__c= Fact1.Fecha_de_pago__c;
            } else if (i > 0){
                date FechaVenc = Fact1.Fecha_emisi_n_factura__c;
                date FechaProxVenc = FechaVenc.toStartOfMonth();
                Integer NumMeses = 12/nf;
                Integer NC = NumMeses * i;
                Venc1.Inicio_de_Facturaci_n__c= FechaProxVenc.addMonths(NC) ;
            }
            Venc1.Fin_de_Facturaci_n__c= (Fact1.Tipo_de_pago__c == 'Tarjeta' || Fact1.Tipo_de_pago__c == 'Web')? Fact1.Fecha_emisi_n_factura__c : Venc1.Inicio_de_Facturaci_n__c;	
            Venc1.Tipo_de_Pago__c= Fact1.Tipo_de_pago__c;
            
            if (Fact1.Tipo_de_Pago__c == 'Domiciliación bancaria') {
                Venc1.BIC_SWIFT__c = Fact1.Cliente__r.BIC_SWIFT__c;
                Venc1.Referencia_recibo__c = Fact1.N_mero_de_factura__c + '/' + Venc1.N_mero_de_pago__c;
                
                String iban = Fact1.Cliente__r.IBAN__c;
                String ibanFormateado = Fact1.Cliente__r.IBAN__c;
                if (iban != null) {
                    iban = iban.replaceAll(' ', '');
                    if (iban.length() == 24) {
                        ibanFormateado = iban.substring(0, 4) + ' ' + iban.substring(4, 8) + ' ' + iban.substring(8, 12) + ' ' + iban.substring(12, 16) + ' ' + 
                            iban.substring(16, 20) + ' ' + iban.substring(20, 24);
                    }
                    //Indicamos si es un residente o no
                    Venc1.Residente__c = (Fact1.Cliente__r.IBAN__c.containsIgnoreCase('ES') == true)? 'S':'N';
                }
                Venc1.IBAN__c = ibanFormateado;
                /*
                //La referencia del mandato es el Id del cliente con mínimo 8 dígitos, sino, se le añaden 0s hasta conseguirlos
                String idCliente = String.valueOf(Fact1.Cliente__r.Id_Cliente__c);
                String refMandato = idCliente;
                if (idCliente.length() < 8) {
                    Integer tam = idCliente.length();
                    for (Integer j = tam; j < 9; j++) {
                        refMandato = '0'+refMandato;
                    }
                }
                Venc1.Referencia_mandato__c = refMandato;
                */
                
                //Fecha firma mandato es la fecha de alta original o la fecha de creación de la cuenta de no socio
                if (Fact1.Cliente__r.Tipo_cuenta__c != 'Cuenta personal') {
                    Datetime fechaCreacion = Fact1.Cliente__r.CreatedDate;
                    Date fecha = Date.newInstance(fechaCreacion.year(), fechaCreacion.month(), fechaCreacion.day());
                    Venc1.Fecha_firma_mandato__c = fecha;
                } else if (Fact1.Cliente__r.Tipo_cuenta__c == 'Cuenta personal') {
                    if (Fact1.Cliente__r.Categor_a__c == 'No_soci' || Fact1.Cliente__r.Categor_a__c == 'Menor No soci' ) {
                        Datetime fechaCreacion = Fact1.Cliente__r.CreatedDate;
                        Date fecha = Date.newInstance(fechaCreacion.year(), fechaCreacion.month(), fechaCreacion.day());
                        Venc1.Fecha_firma_mandato__c = fecha;
                    } else {
                        Venc1.Fecha_firma_mandato__c = Fact1.Cliente__r.Fecha_alta_original__c;
                    }
                }
                
                //Si es la primera domiciliación del cliente, hay que ponerle Tipo adeudo FIRST
                if (CuentasConFacturas.size() > 0) {
                    //System.debug('CuentasConFacturas tam '+CuentasConFacturas);
                    Boolean tieneFacturas = false;
                    //Si el cliente está en CuentasConFacturas, es que ya tiene y por tanto se mantiene el Tipo adeudo por defecto que es RCUR
                    for (Id idCuenta : CuentasConFacturas) {
                        if (idCuenta == Fact1.Cliente__c) {
                            tieneFacturas = true;
                        }
                    }
                    //System.debug('tieneFacturas '+tieneFacturas);
                }
                else { //Como no tiene facturas, le ponemos FRST
                    if (vencimientoPedido.size() < 1) {
                        System.debug('No vencimientos, no facturas');
                        Venc1.Tipo_adeudo__c = 'FRST';
                        if (Fact1.Id_de_Pedido__c != null) {
                            vencimientoPedido.add(Fact1.Id_de_Pedido__c);
                        }
                        if (Fact1.Id_de_Oportunidad__c != null) {
                            vencimientoPedido.add(Fact1.Id_de_Oportunidad__c);
                        }
                    }
                }
                
            } else {
                Venc1.Tipo_adeudo__c = null;
            }
            System.debug('vencimientoNuevo '+Venc1);
            
            listaVencimientos.add(Venc1);  
                
            }
            
            if(listaVencimientos.size() > 0){
                insert listaVencimientos;
                system.debug('listaVencimientos' + listaVencimientos);
            }        
            return ('Se han creado ' + nf + ' cuotas!');
        }
    }