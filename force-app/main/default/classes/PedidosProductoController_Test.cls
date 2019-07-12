/*
*   @clase : PedidosProductoController_Test
*
*   @Author             :   Juan Jose Saez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   20 Sep 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan Jose Saez Martinez         	20 Sep 2018             Creation @istest
*			
*   
*/
@isTest
public class PedidosProductoController_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }

    @isTest
    public static void test1(){
        Account acc1 = TestObjects.createPersonalAccount();
        database.insert (acc1);
        
        Order orde = TestObjects.createOrder( acc1); 
        orde.Etapa__c = '3.Cerrada';
        database.insert (orde);
        
        Product2 prod = TestObjects.createProduct ();
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);
        
        OrderItem ord = TestObjects.createOrderItem( orde,  pri,  prod);
        ord.Asistente__c= acc1.Id ;
        ord.Product2Id = prod.id;
        
        database.insert (ord);
        
        RecordType rt = [SELECT id FROM RecordType WHERE SObjectType=:'Account' AND Name =: 'Cuenta empresa' LIMIT 1];
        Account cuentaEmp = Testobjects.createEmpresaAccount(rt);
        database.insert(cuentaEmp);
        
        Opportunity opp = TestObjects.createOpportunity(); 
        opp.StageName = 'Cerrado éxito';
        opp.AccountId = cuentaEmp.Id;
        database.insert (opp);
        
        OpportunityLineItem oppItem = TestObjects.createOpportunityItem(opp,  pri,  prod);
        database.insert (oppItem);
        
        PedidosProductoController.getOrdersFromProductId(prod.Id);  
        PedidosProductoController.getTotalVendidos(prod.Id);        
  }
    @isTest
    public static void test2(){

         Product2 prod1 = TestObjects.createProduct();
         database.insert (prod1);

        PedidosProductoController.getTotalVendidos(prod1.Id);  
                
  }
   
}