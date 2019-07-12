public with sharing class InfoSocisAppController {
    
	@AuraEnabled
    public static Account getRecord(Decimal socioId) {
        Account accountObject = null;
        List<Account> accountList;
        
        accountList = [SELECT id, name, toLabel(Categor_a__c), Documento_Dni__c, Email_Principal__c, Phone, Id_Cliente__c, N_de_Socio__c, Modalidad__c, N_mero_de_Documento__pc FROM Account WHERE Id_Cliente__c = :socioId LIMIT 1];
        if(!accountList.isEmpty()) 
        	accountObject = accountList[0];

        return accountObject;
    }
    
    @AuraEnabled
    public static List<sObject> getQRInfoList(String recordId) {
        System.debug(recordId);
        List<sObject> returnValue = [SELECT id, Name, Fecha_inicio__c, Fecha_fin__c FROM Info_QR__c WHERE Socio__c = :recordId ];
        System.debug(returnValue);
        return returnValue;
    }
}