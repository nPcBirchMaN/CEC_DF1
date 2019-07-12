/*
*   @clase : CancelOrderItemMailControllerTest
*
*   @Author             :   Melanie Caballero Pastor <melanie.caballero@birchmangroup.com>
*   @Created            :   21 Marzo 2019
*   @Description        :   CancelOrderItemMailControllerTest
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Melanie Caballero Pastor     21 Marzo 2019           Clase Test
*			
*/

@isTest
public class CancelOrderItemMailControllerTest {
    @isTest
    public static void CancelOrderItemMailControllerTest() {

        Product2 prod = TestObjects.createProduct();
        prod.Plazas_disponibles__c = 1;
        insert prod;
       
        
        PageReference pageRef = Page.CancelOrderItemMailTemplate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('products', String.valueOf(prod.Id));
        
        CancelOrderItemMailController co = new CancelOrderItemMailController();
        
    }
    
}