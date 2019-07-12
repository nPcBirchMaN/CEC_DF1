/*
*   @clase : AplicarFuturaSchedulable_Test
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   27/ Sep 2018
*   @Description        :   
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     27 Sep 2018                 Clase Test
*			
*   
*/
@isTest
public class AplicarFuturaSchedulable_Test {
    
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1() {
      AplicarFuturaSchedulable rss = new AplicarFuturaSchedulable();
        String sch = '0 0 23 * * ?';
        Test.StartTest();
			system.schedule('Test AplicarFuturaSchedulable',sch, rss);
        Test.stopTest();
        
    }
}