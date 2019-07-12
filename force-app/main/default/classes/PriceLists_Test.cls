@isTest
public class PriceLists_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void CasoDeInsertMal(){
        Pricebook2 ListaNuevaMal = new Pricebook2();
        ListaNuevaMal.Name = 'Socios';
        ListaNuevaMal.IsActive = TRUE;
        
        database.insert(ListaNuevaMal);
    }
    
    @isTest
    public static void CasoDeUpdateMal(){
        Pricebook2 ListaUpdateMal = new Pricebook2();
        ListaUpdateMal.Name = 'Test';
        ListaUpdateMal.IsActive = TRUE;
        insert ListaUpdateMal;
        
        ListaUpdateMal.Name = 'Socios';
        update ListaUpdateMal;
    }  
        
}