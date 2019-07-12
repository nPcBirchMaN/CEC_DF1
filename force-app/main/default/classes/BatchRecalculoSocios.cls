global class BatchRecalculoSocios implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful {
    /*
     * Pick up all the members in an ordered list [(Ple dret, menor), (Participatiu)]
     * and assign a member number according to the date 'Fecha_trampa__c' when they joined.
     * Ascent order (the older member has a smaller number)
     */
    global Integer numeroSocio;
    global List<Account> start (Database.BatchableContext bc) {
        numeroSocio=0;
        List<Account> returnList = new List<Account>();
        List<Account> listaCuentasPleDretMenor = new List<Account>();
        List<Account> listaCuentasParticipatiu = new List<Account>();
        List<Account> listaCuentasNoSocio = new List<Account>();
        
        // Merge both lists in a single ordered list
        listaCuentasPleDretMenor = [SELECT Id, Categor_a__c, Modalidad__c, Fecha_alta_original__c,Fecha_de_alta_de_actividad__c, Fecha_trampa__c
                                   	FROM Account 
                                    WHERE Categor_a__c = 'Ple_dret' OR Categor_a__c = 'Menor' 
                                    ORDER BY Fecha_trampa__c ASC NULLS LAST];
        
        // Merge both lists in a single ordered list
        listaCuentasParticipatiu = [SELECT Id, Categor_a__c, Modalidad__c, Fecha_alta_original__c,Fecha_de_alta_de_actividad__c, Fecha_trampa__c
                                    FROM Account 
                                    WHERE Categor_a__c = 'Participatiu'
									ORDER BY Fecha_trampa__c ASC NULLS LAST];
        // Merge both lists in a single ordered list
        listaCuentasNoSocio = [SELECT Id, Categor_a__c, Modalidad__c, Fecha_alta_original__c,Fecha_de_alta_de_actividad__c, Fecha_trampa__c
                                    FROM Account 
                                    WHERE Categor_a__c = 'No_soci' OR Categor_a__c = NULL OR Categor_a__c = 'Menor No soci'
									ORDER BY Fecha_trampa__c ASC NULLS LAST];
        
        // Merge both lists in a single ordered list
		returnList.addAll(listaCuentasPleDretMenor);
        returnList.addAll(listaCuentasParticipatiu);
        returnList.addAll(listaCuentasNoSocio);
        
        return  returnList;
    }
    
    global void execute (Database.BatchableContext bc, List<Account> listaCuentas){
        //Integer numeroSocio = 0;
        
        // Iterate over all accounts applying a member number.
        for(Account acc: listaCuentas) {
            if (acc.Categor_a__c != 'No_soci' && acc.Categor_a__c != null && acc.Categor_a__c != 'Menor No soci') {
                acc.N_de_socio__c = ++numeroSocio;
            } else {
                acc.N_de_socio__c = null;
            }
        }
		System.debug('BatchRecalculoSocios listaCuentas :: ' + listaCuentas);
        if(!listaCuentas.isEmpty())
        	database.update (listaCuentas, false);
    }
    
    global void finish (Database.BatchableContext bc){
        SociNumberSchedulable p = new SociNumberSchedulable(); //Schedule apex class name
		String hour = String.valueOf(Datetime.now().hour()+2);
		String min = String.valueOf(Datetime.now().minute()); 
		String ss = String.valueOf(Datetime.now().second());

        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
		system.schedule('Lanzando Update ecommerce número de socio',nextFireTime, p); //system method to schedule apex class
    }      
}