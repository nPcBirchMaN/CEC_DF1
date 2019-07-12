@isTest
public class CrearCuotasSchedule_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
    @isTest
    public static void case1(){
        CrearCuotasSchedule CrearCuotas = new CrearCuotasSchedule();
        String sch = '0 0 23 * * ?';
        Test.startTest();
        	system.schedule('Test CrearCuotas', sch, CrearCuotas);
        Test.stopTest();
     
    }

}