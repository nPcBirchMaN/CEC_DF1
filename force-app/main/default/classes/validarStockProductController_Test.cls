/*   @clase : validarStockProductController_Test
*
*   @Author             :   Juan Jose Saez <juanjose.saez@birchmangroup.com>
*   @Created            :   19 Sep 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Dat                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan José Sáez         	19 Sep 2018             Creation @istest
*			
*   
*/
@istest
public class validarStockProductController_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @istest
    public static void test1(){
        
        Account acc1 = TestObjects.createPersonalAccount();
        database.insert (acc1);
        
        Order orde = TestObjects.createOrder( acc1); 
        orde.Etapa__c = '1.Seguimiento';
        database.insert (orde);
        
        Product2 prod = TestObjects.createProduct();
        
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry(prod);
        database.insert (pri);
        
        OrderItem ord = TestObjects.createOrderItem( orde,  pri,  prod);
        ord.Quantity = 10;
        ord.Asistente__c= acc1.Id ;
        ord.Product2Id = prod.id;
        
        database.insert (ord);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProductStockMockImpl('Suficiente'));
        validarStockProductController.getStockAndSold(prod.Id);
        Test.stopTest();
        
        
    }              
}