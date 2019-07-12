trigger AutoRevistaMontanha on Account (before insert, before update)  {
    System.debug('AutoRevistaMontanha');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        
        for (Account acc: trigger.new){
            //Las cuentas con X tipo de modalidad tienen la asignación automática de la revista montaña.
            if(acc.Modalidad__c == 'Veteranos' ||
               acc.Modalidad__c == 'Veteranos federados' || 
               acc.Modalidad__c == 'Seniors' || 
               acc.Modalidad__c == 'Seniors federados' ||
               acc.Modalidad__c == 'Protector' ||
               acc.Modalidad__c == 'Protector federados' || 
               acc.Modalidad__c == 'Vitalicio'         
              )
            {
                // If is insert, assign automatically.
                if(Trigger.isInsert)
                    acc.Suscriptor_Revista_Monta_a__c = TRUE;
                
                else if(Trigger.isUpdate) {
                    // If is update and modalidad hasnt changed, dont assign it again.
                    if(Trigger.OldMap.get(acc.Id).Modalidad__c == acc.Modalidad__c)
                        continue;
                    // If modalidad changed, calculate again.
                    else if(Trigger.OldMap.get(acc.Id).Modalidad__c != acc.Modalidad__c)
                        acc.Suscriptor_Revista_Monta_a__c = TRUE;
                }
                
            }
        }
        
    }
}