trigger TriggerNumSocio on Account (before insert, before update) { 
    System.debug('TriggerNumSocio');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        
        Account UltCuentaConNumSoc = null;
        //Recuperamos el último número de socio asignado
        List<Account> accs = [SELECT ID, Name, N_de_socio__c FROM Account ORDER BY N_de_socio__c DESC NULLS LAST LIMIT 1];
        if(!accs.isEmpty())
            UltCuentaConNumSoc = accs.get(0);
        
        System.debug('UltCuentaConNumSoc :: ' + UltCuentaConNumSoc);
        for(Account CuentaNueva : Trigger.new){
            if (Trigger.isInsert) {
                //Si es nueva cuenta y su categoría es de tipo socio, se le añadirá un número de socio
                if(UltCuentaConNumSoc != null && UltCuentaConNumSoc.N_de_socio__c != null && CuentaNueva.Categor_a__c != 'No_soci' && CuentaNueva.Categor_a__c != 'Menor No soci' && CuentaNueva.N_de_socio__c == null){
                    //Si existe número de socio anterior, se le suma 1
                    CuentaNueva.N_de_Socio__c = UltCuentaConNumSoc.N_de_socio__c + 1;
                }
                else if ((UltCuentaConNumSoc == null ||  UltCuentaConNumSoc.N_de_socio__c == null) && CuentaNueva.Categor_a__c != 'No_soci' && CuentaNueva.Categor_a__c != 'Menor No soci' && CuentaNueva.N_de_socio__c == null) {
                    CuentaNueva.N_de_Socio__c = 1;
                }
                
            } else {
                //Si se actualiza la categoría de una cuenta y pasa a ser de tipo socio, se le añadirá un número de socio
                Account beforeUpdate = Trigger.oldMap.get(CuentaNueva.Id);
                if(UltCuentaConNumSoc != null && UltCuentaConNumSoc.N_de_socio__c != null && beforeUpdate.Categor_a__c != CuentaNueva.Categor_a__c && CuentaNueva.Categor_a__c != 'No_soci' && CuentaNueva.Categor_a__c != 'Menor No soci' && CuentaNueva.N_de_socio__c == null){
                    CuentaNueva.N_de_Socio__c = UltCuentaConNumSoc.N_de_socio__c + 1;
                } 
                else if ((UltCuentaConNumSoc == null || UltCuentaConNumSoc.N_de_socio__c == null) && beforeUpdate.Categor_a__c != CuentaNueva.Categor_a__c && CuentaNueva.Categor_a__c != 'No_soci' && CuentaNueva.Categor_a__c != 'Menor No soci' && CuentaNueva.N_de_socio__c == null) {
                    CuentaNueva.N_de_Socio__c = 1;
                }
                else if (beforeUpdate.Categor_a__c != CuentaNueva.Categor_a__c && (CuentaNueva.Categor_a__c == 'No_soci' || CuentaNueva.Categor_a__c == 'Menor No soci') && CuentaNueva.N_de_socio__c == null) {
                    //Si se actualiza la categoría de una cuenta y pasa a ser de No socio, se blanquea el número de socio
                    CuentaNueva.N_de_Socio__c = null;
                }
                
            }
            
        }   
        
    }
}