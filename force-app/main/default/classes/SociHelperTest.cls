@isTest
public class SociHelperTest {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void menor6_13Case() {
        
        System.debug([Select id, name from Product2]);
        System.debug([Select id, name from PriceBookEntry]);
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
        
        List<Order> orderList = [SELECT id, name FROM Order WHERE accountId = :acc.Id];
        System.assertEquals(1, orderList.size());
        
        List<OrderItem> enrolmentList = [SELECT id, TotalPrice, Product2.Name, Quantity, Product2.Categor_a__c, Product2.Role_to_assign__c, Product2.Modalidad_a_asignar__c, Product2.Product_type__c FROM OrderItem WHERE OrderId = :orderList[0].id AND Product2.Name LIKE : 'Matrícula'];
		System.assertEquals(0, enrolmentList.size());
        
        List<OrderItem> instalmentList = [SELECT id, TotalPrice, Product2.Name, Quantity, Product2.Categor_a__c, Product2.Role_to_assign__c, Product2.Modalidad_a_asignar__c, Product2.Product_type__c FROM OrderItem WHERE OrderId = :orderList[0].id AND Product2.Name != : 'Matrícula'];
        System.assertEquals(1, instalmentList.size());
        System.assertEquals(18, instalmentList[0].TotalPrice);
        System.assertEquals('Quota anual Soci Infant 6-13 CEC', instalmentList[0].Product2.Name);
        System.assertEquals(1, instalmentList[0].Quantity);
        System.assertEquals('Menor', instalmentList[0].Product2.Role_to_assign__c);
        System.assertEquals('Niños 6-13', instalmentList[0].Product2.Modalidad_a_asignar__c);
        System.assertEquals('subscription', instalmentList[0].Product2.Product_type__c);
        
        Test.stopTest();
    }
    
    @isTest
    public static void vitalicioCase() {
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Vitalicio';
        insert acc;
        
        Test.startTest();
        List<Order> orderList = [SELECT id, name FROM Order WHERE accountId = :acc.Id];
        System.assertEquals(1, orderList.size());
        
        List<OrderItem> enrolmentList = [SELECT id, TotalPrice, Product2.Name, Quantity, Product2.Categor_a__c, Product2.Role_to_assign__c, Product2.Modalidad_a_asignar__c, Product2.Product_type__c FROM OrderItem WHERE OrderId = :orderList[0].id AND Product2.Name LIKE : 'Matrícula'];
		System.assertEquals(1, enrolmentList.size());
        System.assertEquals('Matrícula', enrolmentList[0].Product2.Name);
        System.assertEquals(20, enrolmentList[0].TotalPrice);
        
        List<OrderItem> instalmentList = [SELECT id, TotalPrice, Product2.Name, Quantity, Product2.Categor_a__c, Product2.Role_to_assign__c, Product2.Modalidad_a_asignar__c, Product2.Product_type__c FROM OrderItem WHERE OrderId = :orderList[0].id AND Product2.Name != : 'Matrícula'];
        System.assertEquals(1, instalmentList.size());
        System.assertEquals(0, instalmentList[0].TotalPrice);
        System.assertEquals('Quota anual Soci Vitalici CEC', instalmentList[0].Product2.Name);
        System.assertEquals(1, instalmentList[0].Quantity);
        System.assertEquals('soci', instalmentList[0].Product2.Role_to_assign__c);
        System.assertEquals('Vitalicio', instalmentList[0].Product2.Modalidad_a_asignar__c);
        System.assertEquals('subscription', instalmentList[0].Product2.Product_type__c);
        
        Test.stopTest();
    }
    
    @isTest
    public static void participatiuCase() {
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Participatiu';
        acc.Modalidad__c = null;
        insert acc;
        
        Test.startTest();
        List<Order> orderList = [SELECT id, name FROM Order WHERE accountId = :acc.Id];
        System.assertEquals(1, orderList.size());
        
        List<OrderItem> enrolmentList = [SELECT id, TotalPrice, Product2.Name, Quantity, Product2.Categor_a__c, Product2.Role_to_assign__c, Product2.Modalidad_a_asignar__c, Product2.Product_type__c FROM OrderItem WHERE OrderId = :orderList[0].id AND Product2.Name LIKE : 'Matrícula'];
		System.assertEquals(0, enrolmentList.size());
        
        List<OrderItem> instalmentList = [SELECT id, TotalPrice, Product2.Name, Quantity, Product2.Categor_a__c, Product2.Role_to_assign__c, Product2.Modalidad_a_asignar__c, Product2.Product_type__c FROM OrderItem WHERE OrderId = :orderList[0].id AND Product2.Name != : 'Matrícula'];
        System.assertEquals(1, instalmentList.size());
        System.assertEquals(25, instalmentList[0].TotalPrice);
        System.assertEquals('Quota anual Soci Participatiu CEC', instalmentList[0].Product2.Name);
        System.assertEquals(1, instalmentList[0].Quantity);
        System.assertEquals('soci_participatiu', instalmentList[0].Product2.Role_to_assign__c);
        System.assertEquals(null, instalmentList[0].Product2.Modalidad_a_asignar__c);
        System.assertEquals('subscription', instalmentList[0].Product2.Product_type__c);
        
        Test.stopTest();
    }
    
    @isTest
    public static void EnrolmentExceptionCase() {
        delete [Select id, product2Id, isActive, name from pricebookentry where name Like 'Matrícula' and pricebook2.isStandard = True LIMIT 1];
        Boolean exceptionThrown = false;
        
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Vitalicio';
        
        
        Test.startTest();
        try {
            insert acc;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown);
        
        Test.stopTest();
    }
    
    @isTest
    public static void InstallmentExceptionCase() {
        delete [Select id, Name, Categor_a__c, Role_to_assign__c, Modalidad_a_asignar__c, Product_type__c FROM product2 Where Product_type__c = 'subscription' AND Name LIKE '%Quota anual Soci%'];
        Boolean exceptionThrown = false;
        
        Id cuentaPersonalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.RecordTypeId = cuentaPersonalRecordTypeId;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '123456789K';
        acc.PersonEmail = 'myTestEmail@walidoo.com';
        acc.Categor_a__c = 'Ple_dret';
        acc.Modalidad__c = 'Vitalicio';
        
        
        Test.startTest();
        try {
            insert acc;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown);
        
        Test.stopTest();
    }
}