@isTest
public class UserChangesSynchro_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void testSynchronization() {
        
        Account testAccount = new Account();
        testAccount.LastName = 'Lastname Acc Test';
        testAccount.Categor_a__c = 'Ple_dret';
        testAccount.Modalidad__c = 'Colectivo';
        testAccount.Tipo_de_documento__c = 'dni';
        testAccount.N_mero_de_Documento__pc = '79785079F';
        testAccount.PersonEmail='test@tdssdfsf.com';
        database.insert (testAccount);
        
        string modo = 'update';
        
        UserChangesSynchro.UserChangesSynchronization(modo,testAccount);
    }
}