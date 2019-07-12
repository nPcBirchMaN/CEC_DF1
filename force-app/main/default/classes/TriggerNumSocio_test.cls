/*
*   @clase : TriggerNumSocio_test
*
*   @Author             :   Caroline de Oliveira Pereira <caroline.pereira@birchmangroup.com>
*   @Created            :   28 Ago 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Caroline de Oliveira Pereira         	028 Ago 2018             Creation @istest
*			
*   
*/
@isTest
public class TriggerNumSocio_test 
{
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void caseNoSocis() {
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Menor';
        acc.Modalidad__c = 'Niños 6-13';
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
    }
    
    @isTest
    public static void caseSocis() {
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Vitalicio';
        acc.N_de_socio__c = 2;
        
        Account acc2 = new Account();
        acc2.LastName = 'Test2';
        acc2.RecordTypeId = cuentaPersonalRecordTypeId;
        acc2.Tipo_de_documento__c = 'dni';
        acc2.N_mero_de_Documento__pc = '123456739K';
        acc2.PersonEmail = 'myTestEmail2@walidoo.com';
        acc2.Categor_a__c = 'Ple_dret';
        acc2.Modalidad__c = 'Vitalicio';
        acc2.N_de_socio__c = 1;
        
        Test.startTest();
        insert acc2;
        insert acc;
        Test.stopTest();
        
    }
    /*
    @isTest
    public static void testNumSocio()
    {
        
        Account a = new Account();
        a.Name = 'Test a';
        a.Categor_a__c = 'Ple_dret';
        a.N_de_socio__c = 1;
        database.insert (a);
        
        Account b = new Account();
        b.Name = 'Test b';
        b.Categor_a__c = 'Ple_dret';
        b.N_de_socio__c = null;
        database.insert (b);
        System.assertEquals(b.N_de_socio__c, null);  
        
       
        b.Categor_a__c = 'No_soci';
        database.update (b);
        
        
        Account c = new Account();
        c.Name = 'Test c';
        c.Categor_a__c = 'No_soci';
        c.N_de_socio__c = null;
        database.insert (c);
        
       
        c.Categor_a__c ='Ple_dret';
        database.update (c);
       
    }    
    @isTest
    public static void testNumSocioVacio()
    {
        Account a = new Account();
        a.Name = 'Test a';
        a.Categor_a__c = 'No_soci';
        a.N_de_socio__c = null;
        database.insert (a);

        a.Categor_a__c = 'Ple_dret';
        database.update (a);  
        
    
    }   
*/
}