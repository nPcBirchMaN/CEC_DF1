/*
*   @Class : InfoSocisAppController_Test
*
*   @Author             :   Daniel Palacios <daniel.palacios@birchmangroup.com>
*   @Created            :   17 Dec 2018
*   @Description        :   Testing class for InfoSocisAppController, a controller used in the lightning application "InfoSocisApp".
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------
*   1       Daniel Palacios      	17 Dec 2018             Methods creation: 	setup, searchExistingAccount, searchNonExistingAccount,
*																				searchNonAccountSObject.
*	2       Daniel Palacios      	18 Dec 2018             Methods creation: 	getExistingQRInfo, getNonExistingQRInfo
*/
@isTest
public class InfoSocisAppController_Test {
	
    @TestSetup
    public static void Setup() {
        TestObjects.initializeObjects();
        
        //Account acc = TestObjects.createPersonalAccount();
        Contact con = TestObjects.createContact();
        //acc.Modalidad__c='Seniors';
        //insert acc;
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test1';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79485079F';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Seniors';
        acc.PersonEmail = 'Test56@test56.com';
        acc.Id_Cliente__c=123123;
        
        insert acc;
        insert con;
    }
    
    @isTest
    public static void searchExistingAccount() {
        Account acc = [SELECT id FROM account LIMIT 1];
        
        Test.startTest();
        System.assertNotEquals(acc, InfoSocisAppController.getRecord(123123));
        Test.stopTest();
    }
    
    @isTest
    public static void searchNonExistingAccount() {  
        sObject o;
        
        Test.startTest();
        o = InfoSocisAppController.getRecord(123123);
        System.assertEquals(null, o);
        Test.stopTest();
    }
    
    @isTest
    public static void searchNonAccountSObject() {
        Contact con = [SELECT id FROM contact LIMIT 1];
        
        Test.startTest();
        System.assertEquals(null, InfoSocisAppController.getRecord(123123));
        Test.stopTest();
    }
    
    @isTest
    public static void getExistingQRInfo() {
        Account acc = [SELECT id FROM account LIMIT 1];
        List<Info_QR__c> qrInfos = new List<Info_QR__c>();
        Info_QR__c qrInfo;
        
        for(Integer i = 1; i <= 10; i++) {
           	qrInfo = new Info_QR__c();
        	qrInfo.Name = 'Visita al museo de Cera';
        	qrInfo.Fecha_fin__c = Date.today();
        	qrInfo.Fecha_inicio__c = Date.today();
        	qrInfo.Socio__c = acc.id; 
            qrInfos.add(qrInfo);
        }
        
        insert qrInfos;
        
        Test.startTest();
        System.assertEquals(qrInfos.size(), InfoSocisAppController.getQRInfoList(acc.Id).size());
        Test.stopTest();
    }
    
    @isTest
    public static void getNonExistingQRInfo() {
        Account acc = [SELECT id FROM account LIMIT 1];
        
        Test.startTest();
        System.assertEquals(0, InfoSocisAppController.getQRInfoList(acc.Id).size());
        Test.stopTest();
    }
}