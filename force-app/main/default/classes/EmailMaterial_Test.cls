/*
*   @clase : EmailMaterial_Test
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
public class EmailMaterial_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
			@isTest
    public static void Test1() {
        
        Alquiler_Material__c am = TestObjects.createAlquilerMaterial(); 
        am.Fecha_Fin__c = date.today()+1;
        am.devuelto__c = false;
        insert am;
        
        
        
        System.debug('fecha fin: '+am.Fecha_Fin__c);
        
        Test.startTest();
        EmailMaterial EmailM = new EmailMaterial();
        database.executeBatch(EmailM,50);
        Test.stopTest();
        }
    public static void Test2() {
        
					       
        }
}