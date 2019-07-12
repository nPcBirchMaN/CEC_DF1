@isTest
public class CECResponseMessage_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        String json = '{}';
        CECResponseMessage.parse(json);
    }
}