/*
*   @clase : NewAccountWooCommerce_Test
*
*   @Author             :   Juan Jose Saez <juanjose.saez@birchmangroup.com>
*   @Created            :   30 Ago 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------
*   1       Juan José Sáez         	30 Ago 2018             Creation @istest
*   2       Melanie Caballero       13 Nov 2018             Modification
*
*/
@istest
public class NewAccountWooCommerce_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @istest
    public static void test_menores5(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Menor';
        acc.PersonBirthdate = date.newInstance(hoy.year()-2,01,01);
        acc.Modalidad__c = 'Niños 6-13';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_menores6_13(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Menor';
        acc.PersonBirthdate = date.newInstance(hoy.year()-10,01,01);
        acc.Modalidad__c = 'Niños 6-13';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_menores_13_17(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Menor';
        acc.PersonBirthdate = date.newInstance(hoy.year()-15,01,01);
        acc.Modalidad__c = 'Juniors 14-17';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_jovenes_18_25(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-20,01,01);
        //acc.Modalidad__c = 'Jóvenes 18-25';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_jovenes_18_25_federados(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-20,01,01);
        acc.Modalidad__c = 'Jóvenes 18-25 federados';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_18_25_otros(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-20,01,01);
        //acc.Modalidad__c = 'Jóvenes 26-30';
        
        database.insert (acc);
        Test.stopTest();
    }
     @istest
    public static void test_26_30(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-27,01,01);
        //acc.Modalidad__c = 'Jóvenes 26-30';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_mayores_26_30_federados(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-27,01,01);
        acc.Modalidad__c = 'Jóvenes 26-30 federados';
        
        database.insert (acc);
        Test.stopTest();
    }
 	
    @istest
    public static void test_mayores_30(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-35,01,01);
        acc.Modalidad__c = 'Seniors';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_mayores_30_federados(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-35,01,01);
        acc.Modalidad__c = 'Seniors federados';
        
        database.insert (acc);
        Test.stopTest();
    }
    
    @istest
    public static void test_mayores_26_otros_y_recuperar_ultimo_num_cliente_asignado(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-27,01,01);
        acc.Modalidad__c = 'Jóvenes 18-25 federados';
        
        database.insert (acc);
        
        Account acc1 = TestObjects.createpersonalaccount();
        acc1.webkul_wws__Woo_Customer_Id__c = 'asdb';
        acc1.FirstName = 'Test3';
        acc1.LastName = 'test4';
        acc1.PersonEmail = 'emailTest@test.com';
        acc1.Categor_a__c = 'Ple_dret';
        acc1.PersonBirthdate = date.newInstance(hoy.year()-27,01,01);
        acc1.Modalidad__c = 'Jóvenes 18-25 federados';
        
        database.insert (acc1);
        Test.stopTest();
    }
    
    @istest
    public static void case1(){
        Test.startTest();
        Date hoy = date.today();
        Account acc = TestObjects.createpersonalaccount();
        acc.webkul_wws__Woo_Customer_Id__c = 'asd';
        acc.Categor_a__c = 'Ple_dret';
        acc.PersonBirthdate = date.newInstance(hoy.year()-27,01,01);
        acc.Modalidad__c = 'Seniors federados';
        
        database.insert (acc);
        
        Account acc1 = TestObjects.createpersonalaccount();
        acc1.webkul_wws__Woo_Customer_Id__c = 'asdb';
        acc1.FirstName = 'Test3';
        acc1.LastName = 'test4';
        acc1.PersonEmail = 'emailTest@test.com';
        acc1.Categor_a__c = 'Ple_dret';
        acc1.PersonBirthdate = date.newInstance(hoy.year()-27,01,01);
        acc1.Modalidad__c = 'Vitalicio';
        
        database.insert (acc1);
		Test.stopTest();
    }
    
}