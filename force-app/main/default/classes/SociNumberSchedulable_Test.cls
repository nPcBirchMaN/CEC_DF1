@isTest
public class SociNumberSchedulable_Test {
    
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        acc.Categor_a__c = 'Ple_dret';
        //acc.Modalidad__c = 'Familiar';
        acc.PersonEmail = 'Test@test.com';
        acc.webkul_wws__Woo_Customer_Id__c='12334';
        insert acc;
    }
    
	@isTest
    public static void case1() {
      SociNumberSchedulable rss = new SociNumberSchedulable();
        String sch = '0 0 23 * * ?';
        Test.StartTest();
			system.schedule('Test SociNumberSchedulable',sch, rss);
        Test.stopTest();
        
    }
}