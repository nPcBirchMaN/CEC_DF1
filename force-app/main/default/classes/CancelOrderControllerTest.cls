/*
*   @clase : CancelOrderControllerTest
*
*   @Author             :   Melanie Caballero Pastor <melanie.caballero@birchmangroup.com>
*   @Created            :   20 Marzo 2019
*   @Description        :   CancelOrderControllerTest
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Melanie Caballero Pastor     20 Marzo 2019           Clase Test
*			
*/

@isTest
public class CancelOrderControllerTest {
	
    @testSetup
    public static void setup() {
        TestObjects.initializeObjects();
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Menor';
        acc.Modalidad__c = 'Niños 6-13';
        
        Test.startTest();
        insert acc;
    }
    
    @isTest
    public static void caseSearch() {
        Order o = [SELECT id FROM Order LIMIT 1];
        Test.startTest();
        CancelOrderController.getOrderProducts(o.id, '');
        Test.stopTest();
    }
    
    @isTest
    public static void case1() {
        Account acc = [SELECT id FROM Account LIMIT 1];
        
        Order o = TestObjects.createOrder(acc);
        insert o;
        
        Product2 pro = TestObjects.createProduct();
        	pro.Plazas_disponibles__c = 1;
        insert pro;
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        insert pbe;
        
        OrderItem oi = TestObjects.createOrderItem(o, pbe, pro);
            oi.Quantity = 1;
        
        insert oi;
        
		Integer quan = Integer.valueOf(oi.Quantity);
        JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartArray();
            gen.writeStartObject();
                gen.writeStringField('ID', oi.Id);
                gen.writeNumberField('REFUND_QUANTITY', quan);  
                gen.writeNumberField('REFUND_PRICE', 10.0);
            gen.writeEndObject();
        gen.writeEndArray();
        
        Test.startTest();
        CancelOrderController.process(o.id, gen.getAsString());
        Test.stopTest();
    }
	
}