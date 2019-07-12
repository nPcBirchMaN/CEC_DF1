/*
*   @clase : MailToVocal_Test
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
public class MailToVocal_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void test1(){
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
        
        Order orde = TestObjects.createOrder( acc); 
        database.insert (orde);
        
        
        Empleados__c emp1 = TestObjects.createEmpleados();
        emp1.Name = 'juanjo';
        emp1.Tipo_empleado__c = 'Vocal';
        database.insert (emp1);
        
        Empleados__c emp2 = TestObjects.createEmpleados();
        emp2.Name = 'olaia';
        emp2.Email__c = 'olaia@test.com';
        emp2.Tipo_empleado__c = 'Profesional';
        database.insert (emp2);
        
        
        Product2 prod = TestObjects.createProduct ();
        prod.Name = 'juanjo';
        prod.Vocal__c = emp1.Id;
        prod.Profesional__c = emp2.Id;
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry( prod );
        database.insert (pri);   
        
        OrderItem ori = TestObjects.createOrderItem ( orde, pri,  prod);
        database.insert (ori);
        
        
        MailToVocal.MailVocal(prod.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testSinVoCal(){
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
        
        Order orde = TestObjects.createOrder( acc); 
        database.insert (orde);
        
        Product2 prod = TestObjects.createProduct ();
        prod.Name = 'juanjo';
        database.insert (prod);
        
        PriceBookEntry pri = TestObjects.createPriceBookEntry( prod );
        database.insert (pri);                
        
        MailToVocal.MailVocal(prod.Id);
        Test.stopTest();
    }
}