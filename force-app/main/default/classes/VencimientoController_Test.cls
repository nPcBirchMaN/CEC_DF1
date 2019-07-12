@isTest
public class VencimientoController_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void unaCuota() {
       	Factura__c testFactura = new Factura__c();
        database.insert (testFactura);
        Integer cuotas = 1;
		
		        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert (testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
    }
    @isTest
    public static void dosCuotas() {
        Factura__c testFactura = new Factura__c();
        testFactura.Fecha_emisi_n_factura__c = date.today();
        database.insert (testFactura);
        Integer cuotas = 2;
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert (testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
    }
    @isTest
    public static void unaCuotaTarjeta() {
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Tarjeta';
        database.insert (testFactura);
        Integer cuotas = 1;
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert (testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
    }
    
    @isTest
    public static void case1() {
        
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
        
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura.Fecha_emisi_n_factura__c = date.today();
        testFactura.Id_de_Pedido__c = ord.id;
        testFactura.Cliente__c = acc.Id;
        database.insert (testFactura);
        Integer cuotas = 2;
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert(testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
        
    }
    
    @isTest
    public static void case2() {
        
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
        
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura.Fecha_emisi_n_factura__c = date.today();
        testFactura.Id_de_Pedido__c = ord.id;
        testFactura.Cliente__c = acc.Id;
        database.insert (testFactura);
        Integer cuotas = 2;
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert(testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
        
    }
    @isTest
    public static void case3() {
        
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
        
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura.Fecha_emisi_n_factura__c = date.today();
        testFactura.Id_de_Pedido__c = ord.Id;
        testFactura.Cliente__c = acc.Id;
        database.insert (testFactura);
        Integer cuotas = 2;
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert(testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
        
    }
    @isTest
    public static void case4() {
        
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
        
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura.Fecha_emisi_n_factura__c = date.today();
        testFactura.Id_de_Pedido__c = ord.Id;
        testFactura.Cliente__c = acc.Id;
        database.insert (testFactura);
        Integer cuotas = 2;
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert(testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
        
    }
    
    @isTest
    public static void cuentasConFacturasCase() {
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        
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
        
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        Account accEmpresa = TestObjects.createEmpresaAccount(rt);
        accEmpresa.Contacto__c = con.Id;
        accEmpresa.IBAN__c = 'ES6621000418401234567891';
        database.insert (accEmpresa);
        
        Opportunity opp = TestObjects.createOpportunity();
        opp.AccountId = accEmpresa.Id;
        opp.factura_generada__c = false;
        opp.Tipo_de_Pago__c = 'Domiciliación';
        opp.StageName = 'Nueva';
        database.insert (opp);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, pro);
        database.insert(oppItem);
        
        
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura.Fecha_emisi_n_factura__c = date.today();
        testFactura.Id_de_Oportunidad__c = opp.Id;
        testFactura.Cliente__c = accEmpresa.Id;
        database.insert (testFactura);
        
        Factura__c testFactura2 = new Factura__c();
        testFactura2.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura2.Cliente__c = acc.Id;
        testFactura2.Fecha_emisi_n_factura__c = date.today();
        testFactura2.Id_de_Pedido__c = ord.Id;
        database.insert (testFactura2);
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id);
        database.insert(testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,2);
    }
    
     @isTest
    public static void cuentasSocioConFacturasCase() {
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        
        Account acc = TestObjects.createPersonalAccount();
        acc.IBAN__c = 'ES2431638487754059982862';
        acc.Categor_a__c = 'Ple_dret';
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
        
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        Account accEmpresa = TestObjects.createEmpresaAccount(rt);
        accEmpresa.Contacto__c = con.Id;
        accEmpresa.IBAN__c = 'ES6621000418401234567891';
        database.insert (accEmpresa);
        
        Opportunity opp = TestObjects.createOpportunity();
        opp.AccountId = accEmpresa.Id;
        opp.factura_generada__c = false;
        opp.Tipo_de_Pago__c = 'Domiciliación';
        opp.StageName = 'Nueva';
        database.insert (opp);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, pro);
        database.insert(oppItem);
        
        
        Factura__c testFactura = new Factura__c();
        testFactura.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura.Fecha_emisi_n_factura__c = date.today();
        testFactura.Id_de_Oportunidad__c = opp.Id;
        testFactura.Cliente__c = accEmpresa.Id;
        database.insert (testFactura);
        
        Factura__c testFactura2 = new Factura__c();
        testFactura2.Tipo_de_pago__c = 'Domiciliación bancaria';
        testFactura2.Cliente__c = acc.Id;
        testFactura2.Fecha_emisi_n_factura__c = date.today();
        testFactura2.Id_de_Pedido__c = ord.Id;
        database.insert (testFactura2);
        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura2.Id);
        database.insert(testVencimiento);
        
        VencimientoController.createVencimientos(testFactura2.Id,2);
    }
}