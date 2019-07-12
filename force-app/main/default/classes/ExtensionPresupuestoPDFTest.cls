@isTest
public class ExtensionPresupuestoPDFTest {
    
    @TestSetup
    public static void setup() {
        TestObjects.initializeObjects();
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        Account cuentaEmp = Testobjects.createEmpresaAccount(rt);
        database.insert(cuentaEmp);
		
        Opportunity opp = TestObjects.createOpportunity(); 
        opp.StageName = 'Cerrado éxito';
        opp.AccountId = cuentaEmp.Id;
        database.insert (opp);
        
        Product2 prod = TestObjects.createProduct ();
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp,  pri,  prod);
        database.insert (oppItem);
    }
    
	@isTest
    public static void caseWithOpportunity() {
        Opportunity opp = [select id from opportunity limit 1];        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        ExtensionPresupuestoPDF ext = new ExtensionPresupuestoPDF(sc);
        
    }
}