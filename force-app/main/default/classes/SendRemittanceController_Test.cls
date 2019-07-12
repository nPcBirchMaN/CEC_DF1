@isTest
public class SendRemittanceController_Test {
    
	@testSetup
    public static void setup() {
        TestObjects.initializeObjects();
        
        
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
		        
        Vencimiento__c testVencimiento = new Vencimiento__c(Factura__c = testFactura.Id, Remesada__c = False, Fin_de_Facturaci_n__c = System.today(), Importe_Total__c = 200, IBAN__c = 'ES32482323432442');
        database.insert (testVencimiento);
        
        VencimientoController.createVencimientos(testFactura.Id,cuotas);
    }
    
    @isTest
    public static void case1() {
        System.debug([select id, Remesada__c, Fin_de_Facturaci_n__c, Importe_total__c, Iban__c from Vencimiento__c]);
        Datetime t = Date.today();
        Test.startTest();
        SendRemittanceController.sendToEmail('daniel.palacios@birchmangroup.com', t.format('YYYY-MM-dd'));
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(1, invocations, 'An email should be sent');
    }
}