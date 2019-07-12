@isTest
public class BirchmanGeneralAPI_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        Test.startTest();
        BirchmanGeneralAPI api = new BirchmanGeneralAPI();
        String strHttpMehtod = '';
        String strBody = 'Test';
        String strParam = '';
        String strEndPoint = '';
        List<String> credentialList = new List<String>();
        credentialList.add('');
        api.callAPI(strHttpMehtod, strBody, strParam, strEndPoint, credentialList);
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        api.callAPI(strHttpMehtod, strBody, strParam, strEndPoint, credentialList);
        Test.stopTest();
    }
    
    @isTest
    public static void case2(){
        Test.startTest();
        String strHttpMehtod = '';
        String strBody = 'Test';
        String strParam = '';
        String strEndPoint = '';
        List<String> credentialList = new List<String>();
        credentialList.add('');        
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        BirchmanGeneralAPI.callAPIFuture(strHttpMehtod, strBody, strParam, strEndPoint, credentialList);
        Test.stopTest();
    }
    
    @isTest
    public static void case3(){
        Test.startTest();
        String strHttpMehtod = '';
        String strBody = 'Test';
        String strParam = '';
        String strEndPoint = '';
        List<String> credentialList = new List<String>();
        credentialList.add('');        
        BirchmanGeneralAPI.callAPIFuture(strHttpMehtod, strBody, strParam, strEndPoint, credentialList);
        Test.stopTest();
    }
}