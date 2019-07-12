@isTest
public class TestObjects_Test {
    /*
	
    @isTest
    public static void case1() {
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        System.debug(rt);
        
        Account acc1 = TestObjects.createEmpresaAccount(rt);
        acc1.N_de_socio__c = 1223.0;
        database.insert (acc1);
        
        Account acc2 = TestObjects.createPersonalAccount();
        acc2.N_de_socio__c = 1231.0;
        database.insert (acc2);
        
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        Opportunity opp = TestObjects.createOpportunity();
        database.insert (opp);
        
        Product2 pro = TestObjects.createProduct();
        database.insert (pro);
        
        Etapas_socio__c etapa = TestObjects.createEtapasSocio(acc1);
        database.insert (etapa);
        
        Empleados__c emp = TestObjects.createEmpleados();
        database.insert (emp);
        
        PriceBook2 pb = new PriceBook2(id=Test.getStandardPricebookId());
        
        Order ord = TestObjects.createOrder(acc2);
        ord.Pricebook2Id = pb.id;
        database.insert (ord);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        pbe.Pricebook2Id = pb.id;
        database.insert (pbe);
        
        OrderItem oItem = TestObjects.createOrderItem(ord, pbe, pro);
        database.insert (oItem);
        
        Alquiler_Material__c am = TestObjects.createAlquilerMaterial();
        database.insert(am);
        
        Factura__c factura = TestObjects.createFacturaOrder(ord);
        database.insert(factura);
        
        L_neas_de_factura__c linFac = TestObjects.createLineasFacturaOrder(factura, oItem);
        database.insert(linFac);
        
        Vencimiento__c vencimiento = TestObjects.createVencimientos(factura);
        database.insert(vencimiento);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, pro);
        database.insert(oppItem);
        
        Factura__c facturaOpp = TestObjects.createFacturaOpportunity(opp);
        database.insert(facturaOpp);
        
        L_neas_de_factura__c linFacOpp = TestObjects.createLineasFacturaOpportunity(facturaOpp, oppItem);
        database.insert(linFacOpp);
    }*/
}