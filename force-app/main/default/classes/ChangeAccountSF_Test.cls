@isTest
public class ChangeAccountSF_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void case1(){
        test.startTest();
        system.debug('ANTES FOR');
        /*
for(Integer i=2018; i > 1985; i -= 5){

Account acc = new Account();
acc.LastName = 'Lastname Acc Test' + i;
acc.Categor_a__c = 'Ple_dret';  
acc.Modalidad__c = 'Familiar';  
acc.PersonEmail = 'Test@test.com' + i;
acc.Tipo_de_documento__c = 'dni';
acc.N_mero_de_Documento__pc = '7978507'+i+'F';
database.insert (acc);

acc.Cambios_WooCommerce__c = 'test';
database.update(acc);

acc.Cambios_WooCommerce__c = '';
acc.Categor_a__c ='Menor';
acc.Fecha_alta_original__c = null;
acc.Fecha_de_alta_de_actividad__c = null;
acc.PersonBirthdate = Date.newInstance(i, 1, 1); 

database.update(acc);

}
*/
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Familiar';  
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785074F';
        database.insert (acc);
        
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c ='Menor';
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        acc.PersonBirthdate = Date.newInstance(2018, 1, 1); 
        
        database.update(acc);
        
        test.stopTest();
    }
    @isTest
    public static void case2(){
        test.startTest();
        /*
system.debug('ANTES FOR');
for(Integer i=2018; i > 1985; i -= 5){

Account acc = new Account();
acc.LastName = 'Lastname Acc Test' + i;
acc.Categor_a__c = 'Ple_dret';  
acc.Modalidad__c = 'Jóvenes 18-25 federados';  
acc.PersonEmail = 'Test@test.com' + i;
acc.Tipo_de_documento__c = 'dni';
acc.N_mero_de_Documento__pc = '7978507'+i+'F';

database.insert (acc);

acc.Cambios_WooCommerce__c = 'test';
database.update(acc);

acc.Cambios_WooCommerce__c = '';
acc.Categor_a__c ='Menor';
acc.Fecha_alta_original__c = null;
acc.Fecha_de_alta_de_actividad__c = null;
acc.PersonBirthdate = Date.newInstance(i, 1, 1); 

database.update(acc);

}
*/
        
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Jóvenes 18-25 federados';  
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785075F';
        
        database.insert (acc);
        
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c ='Menor';
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        acc.PersonBirthdate = Date.newInstance(2018, 1, 1); 
        
        database.update(acc);
        
        test.stopTest();
    }
    @isTest
    public static void case3(){
        test.startTest();
        /*
system.debug('ANTES FOR');
for(Integer i=2018; i > 1985; i -= 5){

Account acc = new Account();
acc.LastName = 'Lastname Acc Test' + i;
acc.Categor_a__c = 'Ple_dret';  
acc.Modalidad__c = 'Jóvenes 26-30 federados';  
acc.PersonEmail = 'Test@test.com' + i;
acc.Tipo_de_documento__c = 'dni';
acc.N_mero_de_Documento__pc = '7978507'+i+'F';
database.insert (acc);

acc.Cambios_WooCommerce__c = 'test';
database.update(acc);

acc.Cambios_WooCommerce__c = '';
acc.Categor_a__c ='Menor';
acc.Fecha_alta_original__c = null;
acc.Fecha_de_alta_de_actividad__c = null;
acc.PersonBirthdate = Date.newInstance(i, 1, 1); 

database.update(acc);

}
*/
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Jóvenes 26-30 federados';  
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785078F';
        database.insert (acc);
        
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c ='Menor';
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        acc.PersonBirthdate = Date.newInstance(2018, 1, 1); 
        
        database.update(acc);
        
        test.stopTest();
    }
    @isTest
    public static void case4(){
        test.startTest();
        system.debug('ANTES FOR');
        
        
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Seniors federados';  
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785074F';
        database.insert (acc);
        
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c ='Menor';
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        acc.PersonBirthdate = Date.newInstance(1982, 1, 1); 
        
        database.update(acc);
        
        test.stopTest();
    }
    @isTest
    public static void case5(){
        test.startTest();
        system.debug('ANTES FOR');
        
        
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Seniors';  
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785074F';
        acc.IBAN__c = 'ES6621000418401234567891';
        database.insert (acc);
        
        acc.Cambios_WooCommerce__c = 'test';
        acc.IBAN__c = 'ES6621000418401234567901';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c ='Menor';
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        acc.PersonBirthdate = Date.newInstance(1982, 1, 1); 
        
        database.update(acc);
        
        test.stopTest();
    }
    @isTest
    public static void case6(){
        test.startTest();
        
        /*
system.debug('ANTES FOR');
for(Integer i=2018; i > 1985; i -= 5){

Account acc = new Account();
acc.LastName = 'Lastname Acc Test' + i;
acc.Categor_a__c = 'Ple_dret';  
acc.Modalidad__c = 'Jóvenes 18-25';  
acc.PersonEmail = 'Test@test.com' + i;
acc.Tipo_de_documento__c = 'dni';
acc.N_mero_de_Documento__pc = '7978507'+i+'F';

database.insert (acc);

acc.Cambios_WooCommerce__c = 'test';
database.update(acc);

acc.Cambios_WooCommerce__c = '';
acc.Categor_a__c ='Menor';
acc.Fecha_alta_original__c = null;
acc.Fecha_de_alta_de_actividad__c = null;
acc.PersonBirthdate = Date.newInstance(i, 1, 1); 

database.update(acc);

}

*/
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Jóvenes 18-25';  
        acc.PersonEmail = 'Test@test.com';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        
        database.insert (acc);
        
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c ='Menor';
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        acc.PersonBirthdate = Date.newInstance(2016, 1, 1); 
        
        database.update(acc);
        
        test.stopTest();
    }
    
    @isTest
    public static void case7(){
        test.startTest();
        system.debug('CASO idCliente 1');
        
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.PersonEmail = 'Test1001@test.com';
        acc1.N_mero_de_Documento__pc = '48754684';
        database.insert (acc1);
        
        Account acc = TestObjects.createPersonalAccount();
        acc.Categor_a__c ='No_soci';
        acc.PersonEmail = 'Test@test.com';
        acc.N_mero_de_Documento__pc = '79785074F';
        acc.PersonBirthdate = Date.newInstance(1987, 1, 1); 
        acc.Fecha_alta_original__c = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        database.insert (acc);
        
        System.debug('CASO idCliente 1 INSERT => ' + acc.Id_Cliente__c);
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Seniors';
        database.update(acc);
        System.debug('CASO idCliente 1 UPDATE => ' + acc.Id_Cliente__c);
        test.stopTest();
    }
    
    
    @isTest
    public static void caso8(){ 
        
        test.startTest();
        
        system.debug('CASO idCliente 2');        
        
        Account acc1 = TestObjects.createPersonalAccount();
        acc1.PersonEmail = 'Test1001@test.com';
        acc1.N_mero_de_Documento__pc = '48754684';
        database.insert (acc1);
        
        Account acc = TestObjects.createPersonalAccount();
        acc.Categor_a__c ='No_soci';
        acc.PersonEmail = 'Test@test.com';
        acc.N_mero_de_Documento__pc = '79785074F';
        acc.PersonBirthdate = Date.newInstance(1987, 1, 1); 
        acc.Fecha_alta_original__c = Date.newInstance(2019, 1, 1);
        acc.Fecha_de_alta_de_actividad__c = Date.newInstance(2019, 1, 1);
        database.insert (acc);
        
        System.debug('CASO idCliente 2 INSERT => ' + acc.Id_Cliente__c);
        acc.Cambios_WooCommerce__c = 'test';
        database.update(acc);
        
        acc.Cambios_WooCommerce__c = '';
        
        acc.Categor_a__c = 'Ple_dret';  
        acc.Modalidad__c = 'Seniors';
        
        
        database.update(acc);
        System.debug('CASO idCliente 2 UPDATE => ' + acc.Id_Cliente__c);
        test.stopTest();
    }
}