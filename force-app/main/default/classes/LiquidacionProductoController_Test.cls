@isTest
public class LiquidacionProductoController_Test {
	@testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void conFacturasSinCoste(){
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.Tipo_de_documento__c = 'dni';
        acc1.N_mero_de_Documento__pc = '79785079F';
        database.insert (acc1);
        
        Order orde = TestObjects.createOrder( acc1); 
        orde.Etapa__c = '3.Cerrada';
        database.insert (orde);
        
        Product2 prod = TestObjects.createProduct ();
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);
        
        
        OrderItem ordItem = TestObjects.createOrderItem(orde,  pri,  prod);
        ordItem.Asistente__c= acc1.Id ;
        ordItem.Product2Id = prod.id;
        database.insert (ordItem);
        
        Factura__c factura = TestObjects.createFacturaOrder(orde);
        database.insert (factura);
        
        L_neas_de_factura__c linFactura = TestObjects.createLineasFacturaOrder(factura, ordItem);
        database.insert (linFactura);
        
        LiquidacionProductoController.getFacturasFromProductId(prod.Id);  
        LiquidacionProductoController.getTotalFacturado(prod.Id);        
    }
    
   	@isTest
    public static void conFacturasConCoste(){
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.Tipo_de_documento__c = 'dni';
        acc1.N_mero_de_Documento__pc = '79785079F';
        database.insert (acc1);
        
        Order orde = TestObjects.createOrder( acc1); 
        orde.Etapa__c = '3.Cerrada';
        database.insert (orde);
        
        Product2 prod = TestObjects.createProduct ();
        prod.Coste_total__c = 10;
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);

        OrderItem ordItem = TestObjects.createOrderItem(orde,  pri,  prod);
        ordItem.Asistente__c= acc1.Id ;
        ordItem.Product2Id = prod.id;
        database.insert (ordItem);
        
        Factura__c factura = TestObjects.createFacturaOrder(orde);
        database.insert (factura);
        
        L_neas_de_factura__c linFactura = TestObjects.createLineasFacturaOrder(factura, ordItem);
        database.insert (linFactura);
        
        LiquidacionProductoController.getFacturasFromProductId(prod.Id);  
        LiquidacionProductoController.getTotalFacturado(prod.Id);        
    }
    
    @isTest
    public static void sinFacturasConCoste(){
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.Tipo_de_documento__c = 'dni';
        acc1.N_mero_de_Documento__pc = '79785079F';
        database.insert (acc1);
        
        Order orde = TestObjects.createOrder( acc1); 
        orde.Etapa__c = '3.Cerrada';
        database.insert (orde);
        
        Product2 prod = TestObjects.createProduct ();
        prod.Coste_total__c = 10;
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);

        OrderItem ordItem = TestObjects.createOrderItem(orde,  pri,  prod);
        ordItem.Asistente__c= acc1.Id ;
        ordItem.Product2Id = prod.id;
        database.insert (ordItem);
        
        LiquidacionProductoController.getFacturasFromProductId(prod.Id);  
        LiquidacionProductoController.getTotalFacturado(prod.Id);        
    }
    
     @isTest
    public static void ganaciaCero(){
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.Tipo_de_documento__c = 'dni';
        acc1.N_mero_de_Documento__pc = '79785079F';
        database.insert (acc1);
        
        Product2 prod = TestObjects.createProduct ();
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);

        LiquidacionProductoController.getFacturasFromProductId(prod.Id);  
        LiquidacionProductoController.getTotalFacturado(prod.Id);        
    }
}