/*
*   @clase : BajaAutomaticaController_Test
*
*   @Author             :   Juan Jose Saez <juanjose.saez@birchmangroup.com>
*   @Created            :   28 Ago 2018
*   @Description        :   test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1       Juan José Sáez         	28 Ago 2018             Creation @istest
*			
*   
*/
@istest
public class BajaAutomaticaController_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@istest
    public static void test1(){
        Account acc = TestObjects.createpersonalaccount(); 
        acc.Fecha_baja__c = Date.today();
        acc.Fecha_alta_original__c  =null;
        acc.Baja_solicitada__c = True;
        acc.Fecha_de_alta_de_actividad__c= date.today();
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '59704627P';
        database.insert (acc);
        
        /*
        Factura__c facven = new Factura__c ();
        facven.Cliente__c = acc.id;
        insert  facven;
        
        Vencimiento__c venc = new  Vencimiento__c();
        venc.Factura__c = facven.id;
        venc.Cobrada__c = False;
        insert venc;
        */
        BajaAutomaticaController.getMotivos();
        BajaAutomaticaController.createBajas(acc.id, 'Salud', false );
        BajaAutomaticaController.createBajas(acc.id, 'Defunción', true );        
    }
    @istest
    public static void test2(){
        Account acc = TestObjects.createpersonalaccount(); 
        acc.Fecha_baja__c = Date.today();
        acc.Baja_solicitada__c =true;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '59704627P';
        database.insert (acc);
        
        acc.Fecha_de_alta_de_actividad__c  = null;
        acc.Fecha_alta_original__c = date.today();
        database.update(acc); 
        
        /*
        Factura__c facven = new Factura__c ();
        facven.Cliente__c = acc.id;
        insert  facven;
        
        Vencimiento__c venc = new  Vencimiento__c();
        venc.Factura__c = facven.id;
        venc.Cobrada__c = False;
        insert venc;
        */

        BajaAutomaticaController.createBajas(acc.id, 'Salud', false );

    }
     @istest
    public static void test3(){
        Account acc = TestObjects.createpersonalaccount(); 
        acc.Fecha_baja__c = Date.today();
        acc.Baja_solicitada__c =true;
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '59704627P';
        database.insert (acc);
        
        acc.Fecha_alta_original__c  = null;
        acc.Fecha_de_alta_de_actividad__c = null;
        database.update(acc); 
        
        /*
        Factura__c facven = new Factura__c ();
        facven.Cliente__c = acc.id;
        insert  facven;
        
        Vencimiento__c venc = new  Vencimiento__c();
        venc.Factura__c = facven.id;
        venc.Cobrada__c = False;
        insert venc;
        */

        BajaAutomaticaController.createBajas(acc.id, 'Salud', false );

    }
  }