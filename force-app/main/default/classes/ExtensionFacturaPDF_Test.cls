/*
*   @clase : ExtensionFacturaPDF_Test
*
*   @Author             :   Eduardo Homez <eduardo.homez@birchmangroup.com>
*   @Created            :   13 Nov 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------
*   1       Eduardo Homez         	13 Nov 2018             Creation @istest
*   2       Melanie Caballero       13 Nov 2018             Modification
*
*/

@isTest
public class ExtensionFacturaPDF_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void case1(){
        
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Familiar';
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        database.insert(acc);
        
        
        Order ord = new Order();
        ord.accountid = acc.id;
        ord.EffectiveDate = Date.today();
        ord.Status = 'Borrador';
        ord.Pricebook2Id = Test.getStandardPricebookId();
        database.insert(ord);
    
        
        Factura__c factura = new Factura__c ();
        factura.Name = 'Pedido '+ ord.OrderNumber;
        factura.Cliente__c = ord.AccountId;
        factura.Fecha_emisi_n_factura__c = Date.today();
        factura.Tipo_de_pago__c = ord.Tipo_de_pago__c;
        factura.Tipo_de_Factura__c='Definitiva';
        factura.Id_de_Pedido__c= ord.id;
        database.insert(factura);
        
    }
    
    @isTest
    public static void case2(){
        Account acc = TestObjects.createPersonalAccount();
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
            database.insert(acc);
        Order ord = TestObjects.createOrder(acc);
        	database.insert(ord);
        Product2 pro = TestObjects.createProduct();
        	database.insert(pro);
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        	database.insert(pbe);
        OrderItem oi = TestObjects.createOrderItem(ord, pbe, pro);
        	database.insert(oi);
        Factura__c factura = TestObjects.createFacturaOrder(ord);
        	database.insert(factura);
        
        ApexPages.StandardController stdCtr = new apexPages.StandardController(factura);
		ExtensionFacturaPDF ef = new ExtensionFacturaPDF(stdCtr);
       //ExtensionFacturaPDF.ExtensionFacturaPDF(ApexPages.ctr)
       
    }

}