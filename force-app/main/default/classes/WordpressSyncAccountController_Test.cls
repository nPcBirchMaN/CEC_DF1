@isTest
public class WordpressSyncAccountController_Test {
	 @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
     @isTest
    public static void AccountSyncrhro(){
        
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Seniors';
        acc.PersonEmail = 'Test@test.com';
       	insert acc;
        
        Test.startTest();
        WordpressSyncAccountController.AccountSynchronization(acc.id,'alta');
        Test.stopTest();
    }
}