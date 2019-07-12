@isTest
public class CECProductsApicallout_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        Product2 pro = TestObjects.createProduct();
        insert pro;
        
        database.update (pro);
    }
}