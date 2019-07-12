@isTest
public class PedidoCompletadoEmail_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void test1(){
        Account acc = TestObjects.createPersonalAccount();
        database.insert (acc);
        
        Account acc10 = new Account();
        acc10.LastName = 'Lastname Acc Test10';
        acc10.Categor_a__c = 'Ple_dret';
        //acc.Modalidad__c = 'Familiar';
        acc10.Tipo_de_documento__c = 'dni';
        acc10.N_mero_de_Documento__pc = '79785079F';
        acc10.PersonEmail = 'Test@test.com10';
        
        database.insert(acc10);
        
        Order ord = TestObjects.createOrder(acc);
        ord.Etapa__c = '2.Negociación';
        
        database.insert (ord);
        
        Order ord10 = TestObjects.createOrder(acc10);
        ord10.Etapa__c = '2.Negociación';
        
        database.insert (ord10);
        Date hoy = Date.today();
        Product2 pro= TestObjects.createProduct();
        pro.Product_type__c = 'guide';
        pro.Observaciones_email__c = 'email@test.com';
        pro.Plazas_disponibles__c = 10;
        pro.Plazas_totales__c = 10;
        pro.tax_status__c = 'none';
        pro.Fecha_de_inicio__c = Date.newInstance(hoy.year(), hoy.month()+1, 2);
        pro.Fecha_de_fin__c = Date.newInstance(hoy.year(), hoy.month()+1, 5);
        database.insert (pro);
        
        Product2 pro10= TestObjects.createProduct();
        pro10.Product_type__c = 'guide';
        pro10.Plazas_disponibles__c = 10;
        pro10.Plazas_totales__c = 10;
        pro10.tax_status__c = 'shipping';
        pro10.tax_class__c = 'reduit';
        pro10.Observaciones_email__c = 'email@test.com';
        pro10.Fecha_de_inicio__c = Date.newInstance(hoy.year(), hoy.month()+1, 2);
        pro10.Fecha_de_fin__c = Date.newInstance(hoy.year(), hoy.month()+1, 5);
        database.insert (pro10);
        
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);
        
        PriceBookEntry pbe10 = TestObjects.createPriceBookEntry(pro10);
        database.insert (pbe10);
        
        OrderItem itm = TestObjects.createOrderItem(ord, pbe, pro);
        itm.Asistente__c =null;
        
        OrderItem itm10 = TestObjects.createOrderItem(ord10, pbe10, pro10);
        itm10.Asistente__c = acc10.id;
        
        OrderItem itm1 = TestObjects.createOrderItem(ord, pbe, pro);
        itm10.Asistente__c = acc10.id;
        
        OrderItem itm11 = TestObjects.createOrderItem(ord, pbe10, pro10);
        
        database.insert (itm);
        database.insert(itm10);
        database.insert(itm1);
        database.insert(itm11);
        
        Product2 pro1= TestObjects.createProduct();
        pro1.Observaciones_email__c = 'email@test.com';
        pro1.Product_type__c = 'guide';
        pro1.Plazas_disponibles__c = 10;
        pro1.Plazas_totales__c = 10;
        pro1.tax_status__c = 'none';
        pro1.Name = 'Test2';
        pro1.Fecha_de_inicio__c = Date.newInstance(hoy.year(), hoy.month()+1, 2);
        pro1.Fecha_de_fin__c = Date.newInstance(hoy.year(), hoy.month()+1, 5);
        database.insert (pro1);
        
        Product2 pro2= TestObjects.createProduct();
        pro2.Product_type__c = 'guide';
        pro2.Observaciones_email__c = 'email@test.com';
        pro2.Plazas_disponibles__c = 10;
        pro2.Plazas_totales__c = 10;
        pro2.Name = 'Test3';
        pro2.tax_status__c = 'none';
        pro2.Fecha_de_inicio__c = Date.newInstance(hoy.year(), hoy.month()+1, 2);
        pro2.Fecha_de_fin__c = Date.newInstance(hoy.year(), hoy.month()+1, 5);
        database.insert (pro2);
        
        OrderItem itm2 = TestObjects.createOrderItem(ord, pbe, pro1);
        itm2.Asistente__c = acc.id;
        database.insert (itm2);
        
        OrderItem itm6 = TestObjects.createOrderItem(ord, pbe, pro1);
        //itm6.Asistente__c = acc.id;
        database.insert (itm6);
        
        OrderItem itm3 = TestObjects.createOrderItem(ord, pbe, pro1);
        
        itm3.OrderId = ord.Id;
        //itm3.Asistente__c = null;
        
        
        database.update (ord);
        
         database.update (ord10);
        
        database.insert (itm3);
        
        ord.webkul_wws__woo_Order_Number__c= 9;
        ord.Etapa__c = '3.Cerrada';
        ord.Observaciones_enviadas__c = false;
        ord.Cerrado__c = true;
        ord.Observaciones_enviadas__c = false;
        database.update (ord);
        
        ord10.webkul_wws__woo_Order_Number__c= 9;
        ord10.Etapa__c = '3.Cerrada';
        ord10.Observaciones_enviadas__c = false;
        ord10.Cerrado__c = true;
        ord10.Observaciones_enviadas__c = false;
        database.update (ord10);
        
        
        
    }
}