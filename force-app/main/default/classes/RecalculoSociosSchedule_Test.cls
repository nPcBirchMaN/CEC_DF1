@isTest
public class RecalculoSociosSchedule_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
	@isTest
    public static void case1() {
        RecalculoSociosSchedule rss = new RecalculoSociosSchedule();
        String sch = '0 0 23 * * ?';
        Test.StartTest();
			system.schedule('Test RecalculoSociosSchedule',sch, rss);
        Test.stopTest();
    }
}