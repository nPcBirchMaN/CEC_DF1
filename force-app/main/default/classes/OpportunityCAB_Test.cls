@isTest
public class OpportunityCAB_Test {
    
    @testSetup
    public static void setup() {
        TestObjects.initializeObjects();
        Contact con = TestObjects.createContact();
        database.insert (con);
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        
        Account accEmpresa = TestObjects.createEmpresaAccount(rt);
        accEmpresa.Contacto__c = con.Id;
        accEmpresa.Id_Cliente__c = 3323;
        accEmpresa.IBAN__c = 'ES6621000418401234567891';
        database.insert (accEmpresa);
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'subscription';
        pro.Plazas_Disponibles__c = 10;
        pro.tax_status__c = 'shipping';
        database.insert (pro);
        
        Product2 pro1 = TestObjects.createProduct();
        pro1.Name = 'Test product 1';
        pro1.Product_type__c = 'activity';
        pro1.Plazas_Disponibles__c = 10;
        pro1.tax_status__c = 'taxable';
        pro1.tax_class__c = 'reduit';
        database.insert (pro1);
        
        Product2 pro2 = TestObjects.createProduct();
        pro2.Name = 'Test product 2';
        pro2.Product_type__c = 'activity';
        pro2.Plazas_Disponibles__c = 15;
        database.insert (pro2);
        
        Product2 pro3 = TestObjects.createProduct();
        pro3.Name = 'Test product 3';
        pro3.Product_type__c = 'activity';
        pro3.tax_status__c = 'none';
        pro3.Plazas_Disponibles__c = 15;
        database.insert (pro3);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        pbe.UnitPrice = 15;
        database.insert (pbe);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(pro1);
        database.insert (pbe1);
        
        PriceBookEntry pbe2 = TestObjects.createPriceBookEntry(pro2);
        database.insert (pbe2);
        
        PriceBookEntry pbe3 = TestObjects.createPriceBookEntry(pro3);
        database.insert (pbe3);
        
        Opportunity opp = TestObjects.createOpportunity();
        opp.AccountId = accEmpresa.Id;
        opp.factura_generada__c = false;
        opp.Tipo_de_Pago__c = 'Tarjeta';
        opp.StageName = 'Nueva';
        database.insert (opp);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp, pbe, pro);
        database.insert(oppItem);
        
        OpportunityLineItem oppItem1 = TestObjects.createOpportunityItem(opp, pbe1, pro1);
        database.insert(oppItem1);
        
        OpportunityLineItem oppItem2 = TestObjects.createOpportunityItem(opp, pbe2, pro2);
        database.insert(oppItem2);
        
        OpportunityLineItem oppItem3 = TestObjects.createOpportunityItem(opp, pbe3, pro3);
        database.insert(oppItem3);
        
        
        opp = TestObjects.createOpportunity();
        opp.AccountId = accEmpresa.Id;
        opp.factura_generada__c = false;
        opp.Tipo_de_Pago__c = 'Domiciliación';
        opp.StageName = 'Nueva';
        database.insert (opp);

		oppItem = TestObjects.createOpportunityItem(opp, pbe, pro);
        database.insert(oppItem);
        
        oppItem1 = TestObjects.createOpportunityItem(opp, pbe1, pro1);
        database.insert(oppItem1);
        
        oppItem2 = TestObjects.createOpportunityItem(opp, pbe2, pro2);
        database.insert(oppItem2);
        
        oppItem3 = TestObjects.createOpportunityItem(opp, pbe3, pro3);
        database.insert(oppItem3);        
    }
    
    @isTest
    public static void caseWithFactura() {
        Opportunity opp = [SELECT id, StageName FROM Opportunity WHERE Tipo_de_Pago__c = :'Tarjeta' LIMIT 1];
        
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
        
        opp.StageName = 'Nueva';
        opp.factura_generada__c = false;
        database.update(opp);
        
        Factura__c fac = TestObjects.createFacturaOpportunity(opp);
        fac.Id_de_Oportunidad__c = opp.id;
        fac.Tipo_de_Pago__c = 'Domiciliación bancaria';
        insert fac;
        
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
    }
    
    @isTest
    public static void caseWithFacturaNoIdCliente() {
        Opportunity opp = [SELECT id, StageName, AccountId FROM Opportunity WHERE Tipo_de_Pago__c = :'Tarjeta' LIMIT 1];
        Account acc = [SELECT id, Id_Cliente__c FROM Account WHERE id = :opp.AccountID LIMIT 1];
        acc.Id_Cliente__c = null;
        database.update(acc);
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
        
        opp.StageName = 'Nueva';
        opp.factura_generada__c = false;
        database.update(opp);
        
        Factura__c fac = TestObjects.createFacturaOpportunity(opp);
        fac.Id_de_Oportunidad__c = opp.id;
        fac.Tipo_de_Pago__c = 'Domiciliación bancaria';
        insert fac;
        
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
    }
    
    @isTest
    public static void caseWithNoFacturaNoIdCliente() {
        Opportunity opp = [SELECT id, StageName, AccountID FROM Opportunity WHERE Tipo_de_Pago__c = :'Tarjeta' LIMIT 1];
        Account acc = [SELECT id, Id_Cliente__c FROM Account WHERE id = :opp.AccountID LIMIT 1];
        acc.Id_Cliente__c = null;
        database.update(acc);
        
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
    }
    
    @isTest
    public static void caseWithFacturaDomiciliacion() {
        Opportunity opp = [SELECT id, StageName FROM Opportunity WHERE Tipo_de_Pago__c = :'Domiciliación' LIMIT 1];
        
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
        
        
    }
    
    @isTest
    public static void caseWithoutFactura() {
        Opportunity opp = [SELECT id, StageName FROM Opportunity WHERE Tipo_de_Pago__c = :'Tarjeta' LIMIT 1];
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
    }
    
    
    
    @isTest
    public static void caseWithPresupuesto() {
        Opportunity opp = [SELECT id, StageName FROM Opportunity WHERE Tipo_de_Pago__c = :'Tarjeta' LIMIT 1];
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
    }
    
    @isTest
    public static void caseWithIban() {
        Account acc = [SELECT id, IBAN__c FROM Account LIMIT 1];
        acc.IBAN__c = 'ES6621000418401234567891';
        update acc;
        
        Opportunity opp = [SELECT id, StageName FROM Opportunity WHERE Tipo_de_Pago__c = :'Tarjeta' LIMIT 1];
        opp.StageName = 'Cerrado Éxito';
        database.update(opp);
    }
}