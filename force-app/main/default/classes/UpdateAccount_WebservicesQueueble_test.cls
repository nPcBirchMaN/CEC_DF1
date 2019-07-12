@isTest
public class UpdateAccount_WebservicesQueueble_test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
@isTest
    public static void case1() {
        
        Account acc = TestObjects.createPersonalAccount();
        acc.N_de_socio__c = 0;
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Colectivo';
        database.insert (acc);
        
        acc.Categor_a__c = 'No_soci';
        acc.modalidad__c = '';
        database.update (acc);
        
        Account acc2 = TestObjects.createPersonalAccount();
        acc2.N_de_socio__c = 0;
        acc2.Categor_a__c = 'No_soci';
        acc2.Modalidad__c = null;
        acc2.PersonEmail = 'Test@test2.com';
        database.insert(acc2);
        
        acc2.Categor_a__c = 'Participatiu';
        acc2.Modalidad__c = null;
        database.update(acc2);
        
        Account acc3 = TestObjects.createPersonalAccount();
        acc3.N_de_socio__c = 0;
        acc3.Categor_a__c = 'Participatiu';
        acc3.Modalidad__c = null;
        acc3.PersonEmail = 'Test3@test.com';
        database.insert (acc3);
        acc3.Categor_a__c = 'Ple_dret';
        acc3.Modalidad__c = 'Colectivo';
        database.update (acc3);
        
        
    }
}