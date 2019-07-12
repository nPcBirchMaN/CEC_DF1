@isTest
public class CECProductsAPI_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void testCecProductsAPI() {
        
        String json = '{}';
        CECProductsAPI.parseStock(json);
        CECProductsAPI.parse(json);
        
        Product2 testProduct = new Product2(Name = 'Socios', isActive = true, Impedir_Compra_No_Socio__c= true,Impedir_Compra_Socio__c=true,
                                            Impedir_Compra_Socio_Participativo__c=true, Coordinada_por__c='Test 1, Test 2, Test 3', Product_type__c='subscription',
                                           	Fecha_de_inicio__c = null);
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.IsActive = True;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = testProduct.id;
        pbe.UnitPrice = 10;
        database.insert (pbe);
        
        List <PriceBookEntry> ListPrice = new List <PriceBookEntry>();
        ListPrice.add(pbe);
        
        CECProductsAPI.RellenarProductDataDesdeProducto(testProduct,ListPrice, 'Alta');
        CECProductsAPI.RellenarProductDataDesdeProducto(testProduct,ListPrice, 'Cancelar');       
    }
     @isTest
    public static void testCecProductsAPINoSusc() {
        
        String json = '{}';
        CECProductsAPI.parseStock(json);
        CECProductsAPI.parse(json);
        
        Product2 testProduct = new Product2(Name = 'Socios', isActive = true, Impedir_Compra_No_Socio__c= true,Impedir_Compra_Socio__c=true,
                                            Impedir_Compra_Socio_Participativo__c=true, Coordinada_por__c='Test 1, Test 2, Test 3', Product_type__c='activity',
                                           	Fecha_de_inicio__c = null);
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.IsActive = True;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = testProduct.id;
        pbe.UnitPrice = 10;
        database.insert (pbe);
        
        List <PriceBookEntry> ListPrice = new List <PriceBookEntry>();
        ListPrice.add(pbe);
        
        CECProductsAPI.RellenarProductDataDesdeProducto(testProduct,ListPrice, 'Alta');
        CECProductsAPI.RellenarProductDataDesdeProducto(testProduct,ListPrice, 'Cancelar');       
    }
}