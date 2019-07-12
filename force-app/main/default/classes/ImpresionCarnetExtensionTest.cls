@isTest
public class ImpresionCarnetExtensionTest {
	
    @testSetup
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void test() {
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ImpresionCarnetExtension ice = new ImpresionCarnetExtension(sc);
        ice.getAttachmentId();
    }
}