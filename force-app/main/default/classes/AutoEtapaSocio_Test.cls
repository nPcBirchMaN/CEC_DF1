@isTest
public class AutoEtapaSocio_Test {
	@testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void case1() {
        Test.startTest();
        Account acc = TestObjects.createPersonalAccount();
        acc.N_de_socio__c = 0;
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Colectivo';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '59704627P';
        database.insert (acc);
        
        acc.Categor_a__c = 'No_soci';
        acc.modalidad__c = '';
        database.update (acc);
        
        Account acc2 = TestObjects.createPersonalAccount();
        acc2.N_de_socio__c = 0;
        acc2.Categor_a__c = 'No_soci';
        acc2.Modalidad__c = null;
        acc2.PersonEmail = 'Test@test2.com';
        acc2.Tipo_de_documento__c = 'nie';
        acc2.N_mero_de_Documento__pc = 'Y9011306N';
        database.insert(acc2);
        
        acc2.Categor_a__c = 'Participatiu';
        acc2.Modalidad__c = null;
        database.update(acc2);
        
        Account acc3 = TestObjects.createPersonalAccount();
        acc3.N_de_socio__c = 0;
        acc3.Categor_a__c = 'Participatiu';
        acc3.Modalidad__c = null;
        acc3.PersonEmail = 'Test3@test.com';
        acc3.Tipo_de_documento__c = 'dni';
        acc3.N_mero_de_Documento__pc = '79785075F';
        database.insert (acc3);
        acc3.Categor_a__c = 'Ple_dret';
        acc3.Modalidad__c = 'Colectivo';
        database.update (acc3);
        
        Account acc4 = TestObjects.createPersonalAccount();
        acc4.N_de_socio__c = 0;
        acc4.Categor_a__c = 'Menor No soci';
        acc4.Modalidad__c = null;
        acc4.PersonEmail = 'Test4@test.com';
        acc4.Tipo_de_documento__c = 'nie';
        acc4.N_mero_de_Documento__pc = 'Z8087448D';
        database.insert (acc4);
        acc4.Categor_a__c = 'Ple_dret';
        acc4.Modalidad__c = 'Colectivo';
        database.update (acc4);
        acc4.Categor_a__c = 'Menor No soci';
        acc4.Modalidad__c = null;
        database.update (acc4);
        Test.stopTest();
        
        
    }
}