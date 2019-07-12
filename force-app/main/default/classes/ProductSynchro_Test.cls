@isTest
public class ProductSynchro_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void SynchroError(){
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbe);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Error'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Alta');
        Test.stopTest();
    }

    @isTest
    public static void NoSynchro(){
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.ECommerce__c = false;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbe);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Error'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Alta');
        Test.stopTest();
    }
    @isTest
    public static void SyncError() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 120;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbe);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('SyncError'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Alta');
        Test.stopTest();
    }
    
    @isTest
    public static void SynchroOk() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbe);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Alta');
        Test.stopTest();
    }
    
    @isTest
    public static void CancelarProdEcommerce() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = true;
        testProduct.IsActive = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.PersonEmail = 'test@test1.com';
        
        database.insert (cuenta);
        
        Account cuentaMenor = TestObjects.createPersonalAccount();
        cuenta.PersonEmail = 'testMenor@test2.com';
        
        database.insert (cuentaMenor);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Asistente__c = cuentaMenor.Id;
        database.insert (prodPedido);
        
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        System.debug(rt);
        
        
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        Account accEmpresa = TestObjects.createEmpresaAccount(rt);
        accEmpresa.Contacto__c = con.Id;
        database.insert (accEmpresa);
        
        Opportunity opp = TestObjects.createOpportunity();
        opp.AccountId = accEmpresa.Id;
        database.insert (opp);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, testProduct);
        database.insert(oppItem);
        
        Factura__c facturaPedido = TestObjects.createFacturaOrder(pedido);
        database.insert(facturaPedido);
        
        L_neas_de_factura__c linFacOrd = TestObjects.createLineasFacturaOrder(facturaPedido, prodPedido);
        database.insert(linFacOrd);
        
        Vencimiento__c vencimientoOrd = TestObjects.createVencimientos(facturaPedido);
        database.insert(vencimientoOrd);
        
        Factura__c facturaOpp = TestObjects.createFacturaOpportunity(opp);
        database.insert(facturaOpp);
        
        L_neas_de_factura__c linFacOpp = TestObjects.createLineasFacturaOpportunity(facturaOpp, oppItem);
        database.insert(linFacOpp);
        
        Vencimiento__c vencimientoOpp = TestObjects.createVencimientos(facturaOpp);
        database.insert(vencimientoOpp);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Cancelar');
        Test.stopTest();
    }
    @isTest
    public static void CancelarProdNoEcommerce() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = false;
        testProduct.IsActive = true;
        database.insert (testProduct);
 
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.PersonEmail = 'test@test1.com';
        database.insert (cuenta);
        
        Account cuentaMenor = TestObjects.createPersonalAccount();
        cuenta.PersonEmail = 'testMenor@test2.com';
        database.insert (cuentaMenor);
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        Account accEmpresa = TestObjects.createEmpresaAccount(rt);
        accEmpresa.Contacto__c = con.Id;
        database.insert (accEmpresa);
        
        for (Integer i = 0; i < 4; i++) {
            Order pedido = TestObjects.createOrder(cuenta);
            database.insert (pedido);
            
            OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
            prodPedido.Asistente__c = cuentaMenor.Id;
            database.insert (prodPedido);
            
            Opportunity opp = TestObjects.createOpportunity();
            opp.AccountId = accEmpresa.Id;
            database.insert (opp);
            
            OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, testProduct);
            database.insert(oppItem);
            
            Factura__c facturaPedido = TestObjects.createFacturaOrder(pedido);
            database.insert(facturaPedido);
            
            L_neas_de_factura__c linFacOrd = TestObjects.createLineasFacturaOrder(facturaPedido, prodPedido);
            database.insert(linFacOrd);
            
            L_neas_de_factura__c linFacOrd1 = TestObjects.createLineasFacturaOrder(facturaPedido, prodPedido);
            database.insert(linFacOrd1);
            
            Vencimiento__c vencimientoOrd = TestObjects.createVencimientos(facturaPedido);
            database.insert(vencimientoOrd);
            
            Factura__c facturaOpp = TestObjects.createFacturaOpportunity(opp);
            database.insert(facturaOpp);
            
            L_neas_de_factura__c linFacOpp = TestObjects.createLineasFacturaOpportunity(facturaOpp, oppItem);
            database.insert(linFacOpp);
            
            L_neas_de_factura__c linFacOpp2 = TestObjects.createLineasFacturaOpportunity(facturaOpp, oppItem);
            database.insert(linFacOpp2);
        }

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Cancelar');
        Test.stopTest();
    }
    
    @isTest
    public static void CancelarProdNoEcommerceOpp() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = false;
        testProduct.IsActive = true;
        database.insert (testProduct);
 
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.PersonEmail = 'test@test1.com';
        database.insert (cuenta);
        
        Account cuentaMenor = TestObjects.createPersonalAccount();
        cuenta.PersonEmail = 'testMenor@test2.com';
        database.insert (cuentaMenor);
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        Account accEmpresa = TestObjects.createEmpresaAccount(rt);
        accEmpresa.Contacto__c = con.Id;
        database.insert (accEmpresa);
        
        for (Integer i = 1; i < 4; i++) {
            Opportunity opp = TestObjects.createOpportunity();
            opp.AccountId = accEmpresa.Id;
            database.insert (opp);
            
            OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, testProduct);
            database.insert(oppItem);
            
            Factura__c facturaOpp = TestObjects.createFacturaOpportunity(opp);
        	facturaOpp.Name = 'Factura Opp/'+i;
            database.insert(facturaOpp);
            
            L_neas_de_factura__c linFacOpp = TestObjects.createLineasFacturaOpportunity(facturaOpp, oppItem);
            database.insert(linFacOpp);
            
            L_neas_de_factura__c linFacOpp2 = TestObjects.createLineasFacturaOpportunity(facturaOpp, oppItem);
            database.insert(linFacOpp2);
        }

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Cancelar');
        Test.stopTest();
    }
    
    @isTest
    public static void CancelarProdCancelado() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = false;
        testProduct.IsActive = false;
        database.insert (testProduct);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductSynchroMockImpl('Ok'));
        ProductSynchro.ProductSynchronization(testProduct.Id,'Cancelar');
        Test.stopTest();
    }
    @isTest
    public static void ProdStockSuficiente() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Product2 prod = TestObjects.createProduct();
        prod.Name = 'Test sin Ecommerce';
        prod.Plazas_disponibles__c = 5;
        prod.ECommerce__c = false;
        database.insert (prod);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(prod);
       	database.insert (pbe1);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        OrderItem prodPedidoNoEcomm = TestObjects.createOrderItem(pedido, pbe1, prod);
        prodPedidoNoEcomm.Quantity = 1;
        database.insert (prodPedidoNoEcomm);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.CheckOrderProductsStock(pedido.Id);
        ProductSynchro.GetProductStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void ProdStockInSuficiente() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Product2 prod = TestObjects.createProduct();
        prod.Name = 'Test sin Ecommerce';
        prod.Plazas_disponibles__c = 2;
        prod.ECommerce__c = false;
        database.insert (prod);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(prod);
       	database.insert (pbe1);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 4;
        database.insert (prodPedido);
        
        OrderItem prodPedidoNoEcomm = TestObjects.createOrderItem(pedido, pbe1, prod);
        prodPedido.Quantity = 4;
        database.insert (prodPedidoNoEcomm);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('InSuficiente'));
        ProductSynchro.GetProductStock(pedido.Id);
		ProductSynchro.CheckOrderProductsStock(pedido.Id);        
        Test.stopTest();
    }
    
    @isTest
    public static void ProdStockNoStock() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Product2 prod = TestObjects.createProduct();
        prod.Name = 'Test sin Ecommerce';
        prod.Plazas_disponibles__c = 0;
        prod.ECommerce__c = false;
        database.insert (prod);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(prod);
       	database.insert (pbe1);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        OrderItem prodPedidoNoEcomm = TestObjects.createOrderItem(pedido, pbe1, prod);
        prodPedido.Quantity = 1;
        database.insert (prodPedidoNoEcomm);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('NoStock'));
        ProductSynchro.GetProductStock(pedido.Id);
        ProductSynchro.CheckOrderProductsStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void ProdStocSynchError() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Product2 prod = TestObjects.createProduct();
        prod.Name = 'Test sin Ecommerce';
        prod.Plazas_disponibles__c = 0;
        prod.ECommerce__c = false;
        database.insert (prod);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(prod);
       	database.insert (pbe1);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        OrderItem prodPedidoNoEcomm = TestObjects.createOrderItem(pedido, pbe1, prod);
        prodPedido.Quantity = 1;
        database.insert (prodPedidoNoEcomm);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('SynchError'));
        ProductSynchro.GetProductStock(pedido.Id);
        ProductSynchro.CheckOrderProductsStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void ProdStockSuscripcion() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6001;
        testProduct.ECommerce__c = true;
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.GetProductStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void ProdStockPedidoCerrado() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6001;
        testProduct.Product_type__c = 'subscription';
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        pedido.Etapa__c='3.Cerrada';
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.GetProductStock(pedido.Id);
        ProductSynchro.CheckOrderProductsStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void OrderStockSuscripcion() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6001;
        testProduct.Product_type__c = 'subscription';
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.CheckOrderProductsStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void OrderStockSuficiente() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6000;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Order pedido = TestObjects.createOrder(cuenta);
        database.insert (pedido);
        
        OrderItem prodPedido = TestObjects.createOrderItem(pedido, pbe, testProduct);
        prodPedido.Quantity = 1;
        database.insert (prodPedido);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.CheckOrderProductsStock(pedido.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void StockByProductId() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.webkul_wws__woo_Post_id__c = 6001;
        testProduct.ECommerce__c = true;
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.getStockByProductId(testProduct.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void SoldsByProductId() {
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.ECommerce__c = true;
        testProduct.webkul_wws__woo_Post_id__c = 6001;
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
       	database.insert (pbe);
        
        Account cuenta = TestObjects.createPersonalAccount();
        database.insert (cuenta);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        ProductSynchro.getSoldsByProductId(testProduct.Id);
        Test.stopTest();
    }
}