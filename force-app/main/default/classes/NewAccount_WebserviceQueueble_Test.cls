@isTest
public class NewAccount_WebserviceQueueble_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        CECAccountAPI.UserWordpress userWP = new CECAccountAPI.UserWordpress();
        userWP.roles = new List<String>();
        userWP.roles.add('Test');
        CECAccountAPI.Meta metaData = new CECAccountAPI.Meta();
        metaData.cec_membership_number=String.valueOf(7676);
        userWP.meta=metaData;
        
        QueueableContext context;
        
        NewAccount_WebserviceQueueble q = new NewAccount_WebserviceQueueble('', userWP, '');
        Test.startTest();
        q.execute(null);
        Test.stopTest();
    }
}