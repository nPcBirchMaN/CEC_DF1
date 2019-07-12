/*
*   @clase : PanelDeControlAdministrador_Test
*
*   @Author             :   Juan Jose Saez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   25 Sep 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan Jose Saez Martinez         	25 Sep 2018             Creation @istest
*			
*   
*/
@isTest
public class PanelDeControlAdministrador_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void case1() {
        Boolean pass = False;
        List<Account> lAccounts = new List<Account>();
        Account acc;
        Integer day, month, year;
        for(Integer i = 0; i < 2; i++) {
            acc = new Account();
            acc.LastName = 'Lastname Acc Test' + i;
            acc.Categor_a__c = 'Ple_dret';
            acc.Tipo_de_documento__c = 'dni';
            acc.N_mero_de_Documento__pc = '7978507'+i+'F';
            //acc.Modalidad__c = 'Familiar';
            acc.PersonEmail = 'Test@test.com' + i;
            day = Integer.valueOf(Math.random() * 22 + 1);
            month = Integer.valueOf(Math.random() * 11 + 1);
            year = Integer.valueOf(Math.random()* 40 + 1970);
            System.debug('it' + i + '   ' + day + ' ' + month + ' ' + year);
            if( Math.mod(i, 3) == 0) {
                //acc.N_de_socio__c = 0;
                acc.Categor_a__c = 'Ple_dret';
                acc.Modalidad__c = 'Jóvenes 26-30';
            } else if (Math.mod(i, 2) == 0) {
                acc.Categor_a__c = 'Menor';
                acc.Modalidad__c = 'Juniors 14-17';
            } else {
                acc.Categor_a__c = 'Participatiu';
            }
            acc.Fecha_alta_original__c = date.ValueOf( year + '-' + month + '-'+ day);
            insert acc;
        }
        //insert lAccounts;
        Test.startTest();
        try {
            PanelDeControlAdministradorController.fireBatchRecalculoSocios();
        } Catch(Exception e) {
            pass = True;
        }
        Test.stopTest();
    }
    
    @isTest
    public static void case2(){
        PanelDeControlAdministradorController.fireBatchGenerarRemesaRevistaMuntanya('Tendencia');
    }
}