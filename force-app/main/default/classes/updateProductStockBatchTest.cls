@isTest
public class updateProductStockBatchTest {
	@testSetup
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void case1() {
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Menor';
        acc.Modalidad__c = 'Niños 6-13';
        
        Test.startTest();
        insert acc;
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.ECommerce__c = true;
        testProduct.Inicio_inscripci_n__c = Date.today();
        testProduct.Final_inscripci_n__c = Date.today();
        testProduct.webkul_wws__woo_Post_id__c = 4;
        testProduct.Plazas_totales__c = 10;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbe);
        
        Order o = new Order();
        o.AccountId = acc.Id;
        o.EffectiveDate = Date.today();
        o.Status = 'Draft';
        o.Pricebook2Id = pbe.Pricebook2Id;
        o.Etapa__c = '3.Cerrada';
		insert o;
        
        OrderItem oi = new OrderItem();
        oi.OrderId = o.id;
        oi.Product2Id = testProduct.Id;
        oi.PricebookEntryId = pbe.Id;
        oi.Quantity = 2;
        oi.UnitPrice = 10;
        insert oi;
        
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        
        UpdateProductStockBatch u = new UpdateProductStockBatch();
        Database.executeBatch(u, 1);
        
    }
    
    @isTest
    public static void case2() {
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Menor';
        acc.Modalidad__c = 'Niños 6-13';
        
        Test.startTest();
        insert acc;
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.ECommerce__c = true;
        testProduct.Inicio_inscripci_n__c = Date.today();
        testProduct.Final_inscripci_n__c = Date.today();
        testProduct.webkul_wws__woo_Post_id__c = 4;
        testProduct.Plazas_totales__c = 10;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbe);
        
        Order o = new Order();
        o.AccountId = acc.Id;
        o.EffectiveDate = Date.today();
        o.Status = 'Draft';
        o.Pricebook2Id = pbe.Pricebook2Id;
        o.Etapa__c = '3.Cerrada';
		insert o;
        
        OrderItem oi = new OrderItem();
        oi.OrderId = o.id;
        oi.Product2Id = testProduct.Id;
        oi.PricebookEntryId = pbe.Id;
        oi.Quantity = 2;
        oi.UnitPrice = 10;
        insert oi;
        
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        updateStockSchedulable sh1 = new updateStockSchedulable();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        
    }
}