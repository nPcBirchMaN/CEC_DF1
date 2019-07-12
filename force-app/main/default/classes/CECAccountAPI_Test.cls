@isTest
public class CECAccountAPI_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        String json = '{}';
        CECAccountAPI.parse(json);
    }
}