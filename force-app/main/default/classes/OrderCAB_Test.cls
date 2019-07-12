@isTest
public class OrderCAB_Test {
	@testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void pedidoSimpleShipping() {
        Test.startTest();
        Account acc = TestObjects.createPersonalAccount();
        acc.IBAN__c = 'ES2431638487754059982862';
        acc.Categor_a__c = 'No_soci';
        acc.Id_Cliente__c = 123;
        database.insert (acc);
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'activity';
        pro.Plazas_Disponibles__c = 10;
        pro.tax_status__c = 'shipping';
        database.insert (pro);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);

        Order ord = TestObjects.createOrder(acc);
        ord.Tipo_de_pago__c = 'Tarjeta';
        ord.Recurrente__c = false;
        database.insert (ord);
        
        OrderItem odi = TestObjects.createOrderItem(ord,pbe,pro);
        odi.Quantity = 1;
        odi.UnitPrice = 30;
        database.insert (odi);
        
        ord.Etapa__c = '3.Cerrada';
        ord.Cerrado__c = true;
        database.update(ord);
        Test.stopTest();
    } 
    
    @isTest
    public static void pedidoSimpleSubscription() {
        Test.startTest();
        Account acc = TestObjects.createPersonalAccount();
       	acc.Modalidad__c = 'Familiar';
        database.insert (acc);
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'subscription';
        pro.tax_status__c = 'none';
        database.insert (pro);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);

        Order ord = TestObjects.createOrder(acc);
        ord.Tipo_de_pago__c = 'Domiciliación bancaria';
        ord.Recurrente__c = false;
        database.insert (ord);
        
        OrderItem odi = TestObjects.createOrderItem(ord,pbe,pro);
        odi.Quantity = 1;
        odi.UnitPrice = 30;
        database.insert (odi);
        
        ord.Etapa__c = '3.Cerrada';
        ord.Cerrado__c = true;
        database.update(ord);
        Test.stopTest();
    }
    
    @isTest
    public static void pedidoRecurrente() {
        Test.startTest();
        Account acc = TestObjects.createPersonalAccount();
        acc.IBAN__c = 'ES2431638487754059982862';
        acc.Categor_a__c = 'No_soci';
        acc.Id_Cliente__c = 123;
        database.insert (acc);
        
        Product2 pro = TestObjects.createProduct();
        pro.Name = 'Test product';
        pro.Product_type__c = 'activity';
        pro.Plazas_Disponibles__c = 10;
        pro.tax_status__c = 'taxable';
        pro.tax_class__c = 'reduit';
        database.insert (pro);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        pbe.UnitPrice = 15;
        database.insert (pbe);
        
        Product2 pro1 = TestObjects.createProduct();
        pro1.Name = 'Test product 2';
        pro1.Product_type__c = 'activity';
        pro1.Plazas_Disponibles__c = 15;
        database.insert (pro1);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(pro1);
        database.insert (pbe1);

        Order ord = TestObjects.createOrder(acc);
        ord.Tipo_de_pago__c = 'Tarjeta';
        ord.Recurrente__c = true;
        ord.Periodo_recurrente__c = '3'; 
        database.insert (ord);
        
        OrderItem odi = TestObjects.createOrderItem(ord,pbe,pro);
        odi.Quantity = 1;
        odi.UnitPrice = 30;
        database.insert (odi);
        
        OrderItem odi1 = TestObjects.createOrderItem(ord,pbe1,pro1);
        odi1.Quantity = 1;
        odi1.UnitPrice = 30;
        database.insert (odi1);
        
        ord.Etapa__c = '3.Cerrada';
        ord.Cerrado__c = true;
        database.update(ord);
        Test.stopTest();
    } 
    
    @isTest
    public static void pedidoFacturasPrevias() {
        Test.startTest();
        Account acc = TestObjects.createPersonalAccount();
        acc.IBAN__c = 'ES2431638487754059982862';
        acc.Categor_a__c = 'No_soci';
        acc.Id_Cliente__c = 123;
        database.insert (acc);
        
        Product2 pro = TestObjects.createProduct();
        pro.Name = 'Test product';
        pro.Product_type__c = 'activity';
        pro.Plazas_Disponibles__c = 10;
        pro.tax_status__c = 'taxable';
        pro.tax_class__c = 'reduit';
        database.insert (pro);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        pbe.UnitPrice = 15;
        database.insert (pbe);
        
        Product2 pro1 = TestObjects.createProduct();
        pro1.Name = 'Test product 2';
        pro1.Product_type__c = 'activity';
        pro1.Plazas_Disponibles__c = 15;
        database.insert (pro1);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(pro1);
        database.insert (pbe1);

        Order ord = TestObjects.createOrder(acc);
        ord.Tipo_de_pago__c = 'Domiciliación bancaria';
        ord.Recurrente__c = true;
        ord.Periodo_recurrente__c = '3'; 
        database.insert (ord);
        
        OrderItem odi = TestObjects.createOrderItem(ord,pbe,pro);
        odi.Quantity = 1;
        odi.UnitPrice = 30;
        database.insert (odi);
        
        OrderItem odi1 = TestObjects.createOrderItem(ord,pbe1,pro1);
        odi1.Quantity = 1;
        odi1.UnitPrice = 30;
        database.insert (odi1);
        
        ord.Etapa__c = '3.Cerrada';
        ord.Cerrado__c = true;
        database.update(ord);
        
        
        Order ord1 = TestObjects.createOrder(acc);
        ord1.Tipo_de_pago__c = 'Domiciliación bancaria';
        ord1.Recurrente__c = true;
        ord1.Periodo_recurrente__c = '3'; 
        database.insert (ord1);
        
        OrderItem odi2 = TestObjects.createOrderItem(ord,pbe,pro);
        odi2.Quantity = 1;
        odi2.UnitPrice = 30;
        //database.insert (odi2);
        
        OrderItem odi3 = TestObjects.createOrderItem(ord,pbe1,pro1);
        odi3.Quantity = 1;
        odi3.UnitPrice = 30;
        //database.insert (odi3);
        
        ord1.Etapa__c = '3.Cerrada';
        ord1.Cerrado__c = true;
        //database.update(ord1);
        Test.stopTest();
    } 
}