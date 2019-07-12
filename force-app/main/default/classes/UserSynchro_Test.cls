@isTest
public class UserSynchro_Test {    
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        Account acc = TestObjects.createPersonalAccount();
        acc.N_de_socio__c = 1231.0;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Menor';
        acc.Modalidad__c = 'Niños 6-13';
        database.insert (acc);
        
        List<String> parameters = new List<String>();
        for(;parameters.size() < 10;)
            parameters.add(acc.id);
        
        Test.startTest();
        UserSynchro.UserSynchronization('update', parameters);
        UserSynchro.UserSynchronization('new', parameters);
        Test.stopTest();
    }
    @isTest
    public static void case2(){
        
        Test.startTest();
        UserSynchro.NotifyUser('myTestEmail@walidoo.com', '12345');
        Test.stopTest();
        //UserSynchro.wait(-1);
    }
}