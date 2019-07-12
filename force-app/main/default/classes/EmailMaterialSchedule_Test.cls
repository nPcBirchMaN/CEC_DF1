/*
*   @clase : EmailMaterialSchedule_Test
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   19/ Sep 2018
*   @Description        :   Test de Clase que automatiza el envio de email a clientes que tienen material alquilado y les recuerda que tienen que devolverlo
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     19 Sep 2018                 Clase Test
*			
*   
*/
@isTest
public class EmailMaterialSchedule_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1() {
      EmailMaterialSchedule rss = new EmailMaterialSchedule();
        String sch = '0 0 23 * * ?';
        Test.StartTest();
			system.schedule('Test RecalculoSociosSchedule',sch, rss);
        Test.stopTest();
        
    }
}