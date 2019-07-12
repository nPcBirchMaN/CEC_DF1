@isTest
public class WoopostatusDraft_Test {
	@testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void case1() {
        Product2 pro = TestObjects.createProduct();
        insert pro;
        
        pro.webkul_wws__woo_post_Status__c = 'publish';
        update pro;
    }
}