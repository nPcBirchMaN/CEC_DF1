@isTest
public class BatchRecalculoSocios_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1() {
        //List<Account> lAccounts = new List<Account>();
        //Account acc;
        Integer day, month, year;
        for(Integer i = 0; i < 5; i++) {
            //acc = TestObjects.createPersonalAccount();
            
            Account acc = new Account();
        	acc.LastName = 'Lastname Acc Test' + i;
        	acc.Categor_a__c = 'Ple_dret';
        	//acc.Modalidad__c = 'Familiar';
        	acc.PersonEmail = 'Test@test.com' + i;
            acc.Tipo_de_documento__c = 'dni';
            acc.N_mero_de_Documento__pc = '5970462'+i+'P';
            
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
            } else if (Math.mod(i, 5) == 0) {
            	acc.Categor_a__c = 'No_soci';
            } else {
            	acc.Categor_a__c = 'Participatiu';
            }
            acc.Fecha_alta_original__c = date.ValueOf( year + '-' + month + '-'+ day);

            database.insert(acc);
        }
        //database.insert (lAccounts);
        Test.startTest();
        BatchRecalculoSocios brs = new BatchRecalculoSocios();
        Database.executeBatch(brs, 200);
        Test.stopTest();
    }
}