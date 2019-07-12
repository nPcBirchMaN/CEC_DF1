@isTest
public class BatchGenerarRemesaRevistaMuntanya_Test {    
	@testSetup()
    public static void setup() {
        TestObjects.initializeObjects();
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        Account acc = TestObjects.createEmpresaAccount(rt);
        acc.Id_Cliente__c = 3323;
        acc.IBAN__c = 'ES6621000418401234567891';
        acc.Pagador_Revista_Monta_a__c = true;
        database.insert (acc);
        
		
		Opportunity opp = TestObjects.createOpportunity();
        opp.AccountId = acc.Id;
        opp.factura_generada__c = false;
        opp.Tipo_de_Pago__c = 'Tarjeta';
        opp.StageName = 'Nueva';
        database.insert (opp);
        
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'subscription';
        pro.Plazas_Disponibles__c = 10;
        pro.tax_status__c = 'shipping';
        pro.Name = 'Revista Test 1';
        pro.IsActive = true;
        database.insert (pro);
        
        
        Factura__c fac = TestObjects.createFacturaOpportunity(opp);
        fac.Id_de_Oportunidad__c = opp.id;
        fac.Tipo_de_Pago__c = 'Domiciliación bancaria';
        insert fac;
        
    }
    
    @isTest
    public static void caseTaxShipping() {
        
        Test.startTest();
        BatchGenerarRemesaRevistaMuntanya btch = new BatchGenerarRemesaRevistaMuntanya('Revista Test 1');
        DataBase.executeBatch(btch); 
        Test.stopTest();
    }
    
    @isTest
    public static void caseTaxTaxable() {
        Product2 pro = TestObjects.createProduct();
        pro.Product_type__c = 'subscription';
        pro.Plazas_Disponibles__c = 10;
        pro.tax_status__c = 'taxable';
        pro.tax_class__c = null;
        pro.Name = 'Revista Test 2';
        pro.IsActive = true;
        database.insert (pro);
        
        Test.startTest();
        BatchGenerarRemesaRevistaMuntanya btch = new BatchGenerarRemesaRevistaMuntanya('Revista Test 2');
        DataBase.executeBatch(btch); 
        Test.stopTest();
    }
    
}