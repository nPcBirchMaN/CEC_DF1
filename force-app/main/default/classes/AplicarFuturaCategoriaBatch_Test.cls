/*
*   @clase : AplicarFuturaCategoriaBatch_Test
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   27/ Sep 2018
*   @Description        :   test
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
public class AplicarFuturaCategoriaBatch_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
			@isTest
    public static void Test1() { 
        Account acc = TestObjects.createPersonalAccount();
            acc.Categor_a__c = 'No_soci';
            acc.Fecha_aplicaci_n_de_baja__c = date.today();
        	acc.Suscriptor_Revista_Monta_a__c = true ;
        	acc.Futura_categor_a_s_cio__c ='No_soci';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '59704627P';
        
        database.insert (acc);
        
     
        
        Test.startTest();
        AplicarFuturaCategoriaBatch Aplic = new AplicarFuturaCategoriaBatch();
        database.executeBatch(Aplic,50);
        Test.stopTest();
    }
   }