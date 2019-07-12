/*
*   @clase : AutoRevistaMontanha_Test
*
*   @Author             :   Juan Jose Saez <juanjose.saez@birchmangroup.com>
*   @Created            :   27 Ago 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan José Sáez         	027 Ago 2018             Creation @istest
*			
*   
*/

@istest
public class AutoRevistaMontanha_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@istest
    public static void test1(){
        Test.startTest();
        Account acc = TestObjects.createpersonalaccount();
        acc.Modalidad__c = 'Veteranos';
         acc.Modalidad__c = 'Veteranos federados';
         acc.Modalidad__c =  'Protector';
        acc.Modalidad__c =  'Vitalicio';
        acc.Suscriptor_Revista_Monta_a__c = true;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '59704627P';

        database.insert (acc);
        acc.Modalidad__c =  'Seniors';
        update acc;
        Test.stopTest();
    }
    
}