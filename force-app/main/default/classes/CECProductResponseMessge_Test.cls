@isTest
public class CECProductResponseMessge_Test {
	@testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void case1() {
        CECProductsResponseMessge.ResponseMessage rp = new CECProductsResponseMessge.ResponseMessage();
        CECProductsResponseMessge.parse('{}');
    }
}