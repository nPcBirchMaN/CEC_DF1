trigger onCreateSoci on Account (after insert) {
    System.debug('onCreateSoci');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        System.debug('Trigger Activo');
        List<Account> sociList = new List<Account>();
        
        for(Account acc: Trigger.New) {
            // If it is created from Salesforce
            if(acc.webkul_wws__Woo_Customer_Id__c == null) {
                // Does has a category
                if(String.isNotBlank(acc.Categor_a__c)) {
                    // Is a 'soci'
                    if(acc.Categor_a__c.equalsIgnoreCase('Menor') || acc.Categor_a__c.equalsIgnoreCase('Participatiu') || acc.Categor_a__c.equalsIgnoreCase('Ple_dret') ) {
                        sociList.add(acc);   
                    }
                }
                
            }
        }
        
        System.debug('sl :: ' + sociList);
        if(!sociList.isEmpty())
            SociHelper.createAutomaticSubscriptions(sociList);   
    }    
}