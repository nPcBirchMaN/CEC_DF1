@isTest
public class CustomLookUpControllerTest {    
    @testSetup
    public static void setup() {
       
        
        Product2 pro1 = TestObjects.createProduct();
        pro1.Product_type__c = 'subscription';
        pro1.Plazas_Disponibles__c = 10;
        pro1.tax_status__c = 'shipping';
        pro1.Revista__c = true;
        database.insert (pro1);
        
        Product2 pro2 = TestObjects.createProduct();
        pro2.Product_type__c = 'subscription';
        pro2.Plazas_Disponibles__c = 10;
        pro2.tax_status__c = 'shipping';
        database.insert (pro2);
        
        Product2 pro3 = TestObjects.createProduct();
        pro3.Product_type__c = 'subscription';
        pro3.Plazas_Disponibles__c = 10;
        pro3.tax_status__c = 'shipping';
        database.insert (pro3);
    }
    
	@isTest
    public static void fetchRevistaValuesCase() {
        System.assertEquals(1, customLookUpController.fetchRevistaValues('', 'Product2').size());
        System.assertEquals(0, customLookUpController.fetchRevistaValues('asd', 'Product2').size());
    }
    
    @isTest
    public static void fetchLookUpValues() {
        System.assertEquals(3, customLookUpController.fetchLookUpValues('', 'Product2').size());
        System.assertEquals(0, customLookUpController.fetchLookUpValues('asd', 'Product2').size());
    }
}