@isTest
public class onChangeAccount_WS_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void case1(){
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = 'Ple_dret';
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.Poblaci_n__c = 'Barcelona';
        //cuenta.PersonEmail = null;
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        cuenta.Pais__c = 'NL';
        database.insert (cuenta);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Test.stopTest();
        
        cuenta.Categor_a__c = 'Participatiu';
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test1';
        database.update (cuenta);
        cuenta.FirstName = 'New Test Name';
        database.update (cuenta);
        cuenta.Tipo_de_documento__c = 'NIE';
        database.update (cuenta);
        cuenta.IBAN__c = 'ES7514633520114303972275';
        database.update (cuenta);
        cuenta.Tratamiento_de_datos__c = true;
        database.update (cuenta);
        cuenta.Phone = '666777888';
        database.update (cuenta);
        cuenta.Pais__c = 'ES';
        database.update (cuenta);
        cuenta.Sexo__c = 'woman';
        database.update (cuenta);
        cuenta.Categor_a__c = 'Ple_dret';
        cuenta.Modalidad__c = 'Protector';
        database.update (cuenta);

    }
    
    @isTest
    public static void case2(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = 'Participatiu';
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.PersonEmail = 'test@test2.com';
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        cuenta.Pais__c = 'NL';
        database.insert (cuenta);
        
        cuenta.Categor_a__c = 'No_soci';
        cuenta.Modalidad__c = null;
        database.update (cuenta);
        Test.stopTest();
    }
    
    @isTest
    public static void case3(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = 'No_soci';
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.PersonEmail = 'test@tes3t.com';
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        database.insert (cuenta);
        
        cuenta.Categor_a__c = 'Menor';
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test1';
        database.update (cuenta);
        Test.stopTest();
    }
    
    @isTest
    public static void case4(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = 'Menor';
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.PersonEmail = 'test@test4.com';
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        database.insert (cuenta);
        
        cuenta.Categor_a__c = null;
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test1';
        database.update (cuenta);
        Test.stopTest();
    }
    
    @isTest
    public static void case5(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = null;
        cuenta.Modalidad__c = null;
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.PersonEmail = 'test@test5.com';
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        database.insert (cuenta);
        
        cuenta.Categor_a__c = 'Ple_dret';  
        cuenta.Direcci_n__c = 'Calle test1';
        database.update (cuenta);
        
        Test.stopTest();
    }
    
    @isTest
    public static void case6(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = 'Ple_dret';
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.Poblaci_n__c = 'Barcelona';
        cuenta.PersonEmail = 'test@test6.com';
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        cuenta.Pais__c = 'ES';
        database.insert (cuenta);
        
        Test.stopTest();
    }
    
    @isTest
    public static void case7(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        Account cuenta = TestObjects.createPersonalAccount();
        cuenta.Categor_a__c = 'Ple_dret';
        cuenta.Direcci_n__c = 'Calle test';
        cuenta.Poblaci_n__c = 'Barcelona';
        cuenta.PersonEmail = 'test@test7.com';
        //cuenta.webkul_wws__Woo_Customer_Id__c = '1';
        cuenta.Pais__c = 'ES';
        
        database.insert (cuenta);
        
        Test.stopTest();
    }
    
}