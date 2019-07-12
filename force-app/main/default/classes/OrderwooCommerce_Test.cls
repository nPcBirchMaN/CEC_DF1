@isTest
public class OrderwooCommerce_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void wooCommerceOrder() {
        Account acc = TestObjects.createPersonalAccount();
        database.insert (acc);
        Date hoy = Date.today();
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'activity';
        pro.Fecha_de_inicio__c = Date.newInstance(hoy.year(), hoy.month()+1, 2);
        pro.Fecha_de_fin__c = Date.newInstance(hoy.year(), hoy.month()+1, 5);
        pro.Plazas_Disponibles__c = 10;
        database.insert (pro);
        
       	PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        pbe.IsActive = true;
        database.insert (pbe);
        
        Product2 pro1 = TestObjects.createProduct();
        pro1.Name = 'Matricula';
        pro1.Product_type__c = 'subscription';
        pro1.Licencia__c = true;
        database.insert (pro1);
        
        pro1 = TestObjects.createProduct();
        pro1.Name = 'Matrícula';
        pro1.Product_type__c = 'subscription';
        pro1.Licencia__c = true;
        pro1.isActive = true;
        database.insert (pro1);
        
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(pro1);
        pbe1.UnitPrice = 5;
        pbe1.IsActive = true;
        database.insert (pbe1);
                
        Order ord = TestObjects.createOrder(acc);
        ord.webkul_wws__woo_Order_Number__c = 5;
        ord.webkul_wws__Woo_Order_Status__c = 'wc-pending';
        ord.Extras__c = 'matricula|matricula|5;';
        database.insert (ord);
        
        OrderItem odi = TestObjects.createOrderItem(ord,pbe,pro);
        odi.Quantity = 2;
        database.insert (odi);
        
        ord.webkul_wws__Woo_Order_Status__c = 'wc-completed';
        database.update (ord);
    }
}