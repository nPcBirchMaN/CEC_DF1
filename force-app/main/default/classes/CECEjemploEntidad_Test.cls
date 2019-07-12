@isTest
public class CECEjemploEntidad_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    
	@isTest
    public static void case1(){
        String json = '{}';
        CECEjemploEntidad.parse(json);
    }
}