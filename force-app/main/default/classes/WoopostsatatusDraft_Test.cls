/*
*   @clase : WoopostsatatusDraft_Test
*
*   @Author             :   Juan Jose Saez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   02 Oct 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan Jose Saez Martinez         	02 Oct 2018             Creation @istest
*			
*   
*/
@istest
public class WoopostsatatusDraft_Test {
    @testSetup 
	public static void setup() {
	TestObjects.initializeObjects();
	}
    @istest
    public static void test1(){
        
        Product2 pro= TestObjects.createProduct();
        pro.webkul_wws__woo_post_Status__c = 'draft';
        
        database.insert (pro);
        
    }   
}