@isTest
public class TestDataFactory {
	
    public static List<Account> createPersonAccounts(Integer n) {
        List<Account> accList = new List<Account>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
		Account acc;
        
        for(Integer i = 0; i < n; i++) {
			acc = new Account();
			acc.LastName = 'Lastname Acc Test';
            acc.Categor_a__c = 'Ple_dret';
            acc.Modalidad__c = 'Familiar';
            acc.PersonEmail = 'Test@test.com';
            acc.Tipo_de_documento__c = 'dni';
            acc.N_mero_de_Documento__pc = '79785079F';
			accList.add(acc);            
        }
        
        insert accList;
        return accList;
    }
    
    public List<Account> createBusinessAccounts(Integer n) {
        List<Account> accList = new List<Account>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta empresa').getRecordTypeId();
        
        insert accList;
        return accList;
    }
}