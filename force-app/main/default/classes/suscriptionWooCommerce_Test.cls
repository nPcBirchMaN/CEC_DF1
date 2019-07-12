@isTest
public class suscriptionWooCommerce_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void case1() {
        Account acc = TestObjects.createPersonalAccount();
        database.insert (acc);
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'subscription';
        pro.tax_status__c = 'none';
        pro.Role_to_assign__c = 'soci';
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
    }
    @isTest
    public static void case2(){
        Account acc = TestObjects.createPersonalAccount();
        database.insert (acc);
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'subscription';
        pro.tax_status__c = 'none';
        pro.Role_to_assign__c = 'soci_participatiu';
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
        
    }
}