global class RecalculoDeSociosAC {
    @AuraEnabled
    webservice static String RecalculoSocios (String RegistroID){
        
        integer numeroSocioAsignar = 1;
        
        List<Account> ListaCuentasPleMenor = [SELECT Id, Categor_a__c, Modalidad__c, Fecha_alta_original__c,Fecha_de_alta_de_actividad__c, Fecha_trampa__c
                                              FROM Account 
                                              WHERE Categor_a__c = 'ple_dret' OR Categor_a__c = 'Menor' 
                                              ORDER BY Fecha_trampa__c ASC NULLS LAST];
        
        System.debug('Tam lista1' + ListaCuentasPleMenor.size());

		List<Account> ListaCuentasPart = [SELECT Id, Categor_a__c, Modalidad__c, Fecha_alta_original__c,Fecha_de_alta_de_actividad__c, Fecha_trampa__c
                                          FROM Account 
                                          WHERE Categor_a__c = 'Participatiu'
										  ORDER BY Fecha_trampa__c ASC NULLS LAST];
        
        System.debug('Tam lista2' + ListaCuentasPart.size());
        
            ListaCuentasPleMenor.addAll(ListaCuentasPart);
        
        System.debug('Tam lista3' + ListaCuentasPleMenor.size());
        
        for(Account CuentasPleMenorPart : ListaCuentasPleMenor) {
            CuentasPleMenorPart.N_de_socio__c = numeroSocioAsignar ;
			numeroSocioAsignar++;
        }
        database.update (ListaCuentasPleMenor);
        
    return ('El recalculo se ha realizado correctamente!');    
    }  
}