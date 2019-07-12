global class BajaAutomaticaController {
    @AuraEnabled
    webservice static String createBajas (String IdCuenta, String valoret,boolean instantea ){
        
        Account[] CuentaBaja = [SELECT Id, Fecha_baja__c, Baja_Solicitada__c,  Categor_a__c, Modalidad__c, Motivo_de_la_baja__c, Fecha_alta_original__c, Fecha_de_alta_de_actividad__c, Pagador_Revista_Monta_a__c,
                                Fecha_aplicaci_n_de_baja__c, Futura_categor_a_s_cio__c, Futura_modalidad_del_socio__c, Fecha_renovaci_n_suscripci_n__c, Fecha_de_ltima_actualizaci_n__c, Newsletter__c, 
                                Suscriptor_Revista_Monta_a__c, N_de_Socio__c, Licencia__c FROM Account WHERE Id =: IdCuenta];
        
        System.debug('IdCuenta' + IdCuenta);
        System.debug('valoret' + valoret);
        
        if(!String.isEmpty(valoret))
        {
            if (instantea==true) {
            	CuentaBaja[0].Categor_a__c = 'No_soci'; 
                CuentaBaja[0].Modalidad__c = null;
                CuentaBaja[0].N_de_Socio__c = null;
            	CuentaBaja[0].Licencia__c = null;
                CuentaBaja[0].Fecha_aplicaci_n_de_baja__c = null;
                CuentaBaja[0].Futura_categor_a_s_cio__c = null;
                CuentaBaja[0].Futura_modalidad_del_socio__c = null;
                CuentaBaja[0].Fecha_renovaci_n_suscripci_n__c = null;
                CuentaBaja[0].Suscriptor_Revista_Monta_a__c = False;
                CuentaBaja[0].Pagador_Revista_Monta_a__c = false;
                CuentaBaja[0].Newsletter__c = false;
            } else {
                Date fechaActual = Date.today();
                Integer actualYear = fechaActual.year();
                Date fechaAlta = CuentaBaja[0].Fecha_de_alta_de_actividad__c;
                Integer pastYear;
                Date fechaFutura;
                if (fechaAlta != null) {
                    pastYear = fechaAlta.year();
                    fechaFutura = CuentaBaja[0].Fecha_de_alta_de_actividad__c;
                } else if(CuentaBaja[0].Fecha_alta_original__c != null) {
                    fechaAlta = CuentaBaja[0].Fecha_alta_original__c;
                    pastYear = fechaAlta.year();
                    fechaFutura = CuentaBaja[0].Fecha_alta_original__c;
                } else {
                    pastYear = actualYear;
                    fechaFutura = Date.today();
                }
                Integer years = actualYear - pastYear;
                fechaFutura = fechaFutura.addYears(years + 1);
                CuentaBaja[0].Fecha_aplicaci_n_de_baja__c = CuentaBaja[0].Fecha_renovaci_n_suscripci_n__c;
                CuentaBaja[0].Futura_categor_a_s_cio__c = 'No_soci';
                System.debug('Lo paso a No Soci');
                CuentaBaja[0].Futura_modalidad_del_socio__c = null;
            }
            CuentaBaja[0].Fecha_de_ltima_actualizaci_n__c = Date.today();
            CuentaBaja[0].Fecha_baja__c = Date.today();
            CuentaBaja[0].Baja_Solicitada__c = TRUE;
            CuentaBaja[0].Motivo_de_la_baja__c = valoret;
            CuentaBaja[0].Fecha_renovaci_n_suscripci_n__c = null;
            
        }
   		/*
        List<Factura__c> listFacturasaCerrar = [SELECT Cobrada__c,Id,Name,N_mero_de_factura__c FROM Factura__c WHERE Cliente__c =: IdCuenta];
        system.debug('listFacturasaCerrar' + listFacturasaCerrar );
        
        for(Factura__c FacturasconVencimientos: listFacturasaCerrar ){
            
            FacturasconVencimientos.Cobrada__c = True;
            
            List<Vencimiento__c> listVencimientosaBorrar = [SELECT Factura__c, Id, Cobrada__c, Name, Nombre_de_la_factura__c, N_mero_de_Factura__c
                                                            FROM Vencimiento__c WHERE Factura__c =: FacturasconVencimientos.Id AND Cobrada__c = FALSE];
            
            system.debug('listVencimientosaBorrar '+listVencimientosaBorrar);
            
            if (listVencimientosaBorrar.size() > 0){
                delete listVencimientosaBorrar;
            }
          
        }
        
        if(listFacturasaCerrar.size() > 0){
            update listFacturasaCerrar;
        }
        */
        database.update (CuentaBaja[0]);
        
        return ('El cliente ha sido dado de baja!.'); 
    }
    @AuraEnabled
    public static List<String> getMotivos () {
        List<String> finalResult =  new List<String>();
        Schema.DescribeFieldResult field = Account.Motivo_de_la_baja__c.getDescribe();
        
        for (Schema.PicklistEntry f : field.getPicklistValues())
        	finalResult.add(f.getLabel());
        
        finalResult.sort();
        return finalResult;
    }
}