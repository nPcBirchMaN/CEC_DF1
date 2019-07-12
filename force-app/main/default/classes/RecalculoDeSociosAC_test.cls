/*
*   PostCreateAudit_Test
*
*   @Author             :   Melanie Caballero Pastor <melanie.caballero@birchmangroup.com>
*   @Created            :   27 Ago 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------
*   1       Melanie Caballero         27 Ago 2018             Creation @istest
*
*/

@isTest
public class RecalculoDeSociosAC_test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void test1(){
        
		Account acc1 = testObjects.createPersonalAccount();
        acc1.PersonEmail = 'test@test1.com';
        Account acc2 = testObjects.createPersonalAccount();
        acc2.PersonEmail = 'test@test2.com';
        Account acc3 = testObjects.createPersonalAccount();
        acc3.PersonEmail = 'test@test3.com';
        database.insert (acc1);
        database.insert (acc2);
        database.insert (acc3);
        
        acc2.Categor_a__c =  'Menor';
       
        acc3.Categor_a__c = 'Participatiu';
        
        database.update (acc2);
        database.update (acc3);
        
        RecalculoDeSociosAC.RecalculoSocios (acc1.Id);
    }
}