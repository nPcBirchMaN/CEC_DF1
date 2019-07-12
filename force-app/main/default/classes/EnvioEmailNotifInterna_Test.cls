/*
*   @clase : EncioEmailNotifInterna_test
*
*   @Author             :   Juan Jose Saez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   19 Sep 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan Jose Saez Martinez         	19 Sep 2018             Creation @istest
*			
*   
*/
@isTest
public class EnvioEmailNotifInterna_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void test1(){
        
        Account acc = TestObjects.createPersonalAccount();
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785071F';
        database.insert (acc);
        
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.LastName = 'Test2';
        acc1.PersonEmail = 'test2@email.com';
        acc1.Tipo_de_documento__c = 'dni';
        acc1.N_mero_de_Documento__pc = '79785074F';
        database.insert (acc1);
        System.debug('acc '+acc);
        
        Order ord = TestObjects.createOrder(acc);
        ord.Etapa__c = '2.Negociación';
        database.insert (ord);
        
        Product2 pro= TestObjects.createProduct();
        pro.Email_de_notificaci_n_interna__c = 'email@test.com';
        pro.Plazas_disponibles__c = 10;
        pro.Plazas_totales__c = 10;
        database.insert (pro);
        
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);
        
        OrderItem itm = TestObjects.createOrderItem(ord, pbe, pro);
        itm.Asistente__c = acc1.id;
        database.insert (itm);
        
        Product2 pro1= TestObjects.createProduct();
        pro.Email_de_notificaci_n_interna__c = 'email@test.com';
        pro1.Name = 'Test2';
        pro1.Plazas_disponibles__c = 10;
        pro1.Plazas_totales__c = 10;
        database.insert (pro1);
        
        OrderItem itm2 = TestObjects.createOrderItem(ord, pbe, pro1);
        itm2.Asistente__c = null;
        database.insert (itm2);
        
        ord.webkul_wws__woo_Order_Number__c= 9;
        ord.Etapa__c = '3.Cerrada';
        ord.Notificaci_n_interna__c = false;
        ord.Cerrado__c = true;
        database.update (ord);
    }
    
    @isTest
    public static void test2(){
        
        Account acc = TestObjects.createPersonalAccount();
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        database.insert (acc);
        
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.LastName = 'Test2';
        acc1.PersonEmail = 'test2@email.com';
        acc1.Tipo_de_documento__c = 'dni';
        acc1.N_mero_de_Documento__pc = '79785074F';
        
        database.insert (acc1);
        System.debug('acc '+acc);
        
        Order ord = TestObjects.createOrder(acc);
        ord.Etapa__c = '2.Negociación';
        database.insert (ord);
        
        Product2 pro= TestObjects.createProduct();		
        pro.Plazas_disponibles__c = 10;
        pro.Plazas_totales__c = 10;
        pro.Email_de_notificaci_n_interna__c = 'email@test.com';
        database.insert (pro);
        
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);
        
        OrderItem itm = TestObjects.createOrderItem(ord, pbe, pro);
        itm.Asistente__c = null;
        database.insert (itm);
        
        Product2 pro1= TestObjects.createProduct();
        pro1.Plazas_disponibles__c = 10;
        pro1.Plazas_totales__c = 10;
        pro1.Email_de_notificaci_n_interna__c = 'email@test.com';
        pro1.Name = 'Test2';
        
        database.insert (pro1);
        
        OrderItem itm2 = TestObjects.createOrderItem(ord, pbe, pro1);
        database.insert (itm2);
        
        
        ord.webkul_wws__woo_Order_Number__c= 9;
        ord.Etapa__c = '3.Cerrada';
        ord.Notificaci_n_interna__c = false;
        ord.Cerrado__c = true;
        database.update (ord);
    }
			
}