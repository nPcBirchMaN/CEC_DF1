/*
*   @clase : UpdataAccount_WebservicesQueueble_test
*
*   @Author             :   Juan Jose Saez <juanjose.saez@birchmangroup.com>
*   @Created            :   28 Ago 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan José Sáez         	28 Ago 2018             Creation @istest
*			
*   
*/
@isTest
public class UpdataAccount_WebservicesQueueble_test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void test1() {
        Account acc = TestObjects.createPersonalAccount();
        insert acc;
        
    }   
}