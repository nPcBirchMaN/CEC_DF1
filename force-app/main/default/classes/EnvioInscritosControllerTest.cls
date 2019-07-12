/*
*   @clase : EnvioInscritosControllerTest
*
*   @Author             :   Melanie Caballero Pastor <melanie.caballero@birchmangroup.com>
*   @Created            :   27 Marzo 2019
*   @Description        :   EnvioInscritosControllerTest
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Melanie Caballero Pastor     27 Marzo 2019           Clase Test
*			
*/

@isTest
public class EnvioInscritosControllerTest {
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
    public static void case1() {
        Account acc = [SELECT id FROM Account LIMIT 1];
        
        Order o1 = TestObjects.createOrder(acc);
        	o1.Etapa__c = '3.Cerrada';
        insert o1;
        
         Order o2 = TestObjects.createOrder(acc);
        	o2.Etapa__c = '0.Inicial';
        insert o2;
        
        Order o3 = TestObjects.createOrder(acc);
        	o3.Etapa__c = '3.Cerrada';
        insert o3;
        
         Order o4 = TestObjects.createOrder(acc);
        	o4.Etapa__c = '0.Inicial';
        insert o4;
        
        Product2 pro = TestObjects.createProduct();
        	pro.Plazas_disponibles__c = 1;
        insert pro;
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        insert pbe;
        
        OrderItem oi1 = TestObjects.createOrderItem(o1, pbe, pro);
            oi1.Quantity = 1;
        	oi1.L_nea_Anulada__c = true;
        insert oi1;
        
        OrderItem oi2 = TestObjects.createOrderItem(o2, pbe, pro);
            oi2.Quantity = 1;
        	oi2.L_nea_Anulada__c = true;
        insert oi2;
        
        OrderItem oi3 = TestObjects.createOrderItem(o3, pbe, pro);
            oi1.Quantity = 1;
        	oi3.L_nea_Anulada__c = false;
        insert oi3;
        
        OrderItem oi4 = TestObjects.createOrderItem(o4, pbe, pro);
            oi4.Quantity = 1;
        	oi4.L_nea_Anulada__c = false;
        insert oi4;
        
        PageReference pageRef = Page.EnvioInscritosPDF;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', String.valueOf(pro.Id));
                
        EnvioInscritosController eic = new EnvioInscritosController();
        eic.getProduct();
        eic.getListaInscritos();
        eic.getListaEspera();
        eic.getListaBajas();

    }
    
}