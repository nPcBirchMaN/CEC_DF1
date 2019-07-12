/*
*   @clase : NoCerrarPedido_Test
*
*   @Author             :   Juan Jose Saez <juanjose.saez@birchmangroup.com>
*   @Created            :   03 Sep 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan José Sáez         	03 Ago 2018             Creation @istest
*			
*   
*/
@istest
public class NoCerrarPedido_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @istest
    public static void test1(){
        Account acc = TestObjects.createpersonalaccount(); 
        acc.FirstName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Colectivo';
        database.insert (acc);
        
        
        System.debug('acc '+acc);
        Order ord = TestObjects.createOrder(acc);
        ord.Etapa__c = '1.Seguimiento';
        ord.webkul_wws__woo_Order_Number__c = null;
        database.insert (ord);
        
        Product2 pro= TestObjects.createProduct();
        database.insert (pro);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);
        
        OrderItem itm = TestObjects.createOrderItem(ord, pbe, pro);
        database.insert (itm);
        
        ord.Etapa__c = '3.Cerrada';
        ord.webkul_wws__woo_Order_Number__c = null;
        ord.Cerrado__c = true;
        database.update (ord);
         
    }
   
    @istest
    public static void test3(){
        Account acc = TestObjects.createpersonalaccount(); 
        acc.FirstName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Colectivo';
        database.insert (acc);
        
        System.debug('acc '+acc);
        Order ord = TestObjects.createOrder(acc);
        ord.Etapa__c = '1.Seguimiento';
        ord.Cerrado__c = false;
        ord.webkul_wws__woo_Order_Number__c = null;
        
        
        database.insert (ord);
        
        Product2 pro= TestObjects.createProduct();
        database.insert (pro);
        
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(pro);
        database.insert (pbe);
        
        OrderItem itm = TestObjects.createOrderItem(ord, pbe, pro);
        database.insert (itm);
        
        ord.Etapa__c = '3.Cerrada';
        ord.webkul_wws__woo_Order_Number__c = null;
        ord.Cerrado__c = false;
        database.update (ord);
  
    }

}