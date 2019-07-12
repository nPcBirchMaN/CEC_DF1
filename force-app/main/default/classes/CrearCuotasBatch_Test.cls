@isTest
public class CrearCuotasBatch_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @isTest
    public static void CuotasConPromo() {
        Test.startTest();
        Maestro_de_Promociones__c promo = new Maestro_de_Promociones__c();
        promo.Desccuento__c = 50;
        promo.Name = 'Descuento 50%';
        Database.insert(promo);
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.Name = 'Test';
        testProduct.Role_to_assign__c = 'soci';
        testProduct.Modalidad_a_asignar__c = 'Jóvenes 26-30';
        testProduct.tax_status__c = 'taxable';
        testProduct.tax_class__c = 'zero';
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        Product2 testProduct2 = TestObjects.createProduct();
        testProduct2.Name = 'Suplemento';
        testProduct2.Product_type__c = 'subscription';
        database.insert (testProduct2);
        
        Product2 testProduct3 = TestObjects.createProduct();
        testProduct3.Name = 'Test participatiu';
        testProduct3.Role_to_assign__c = 'soci_participatiu';
        testProduct3.Modalidad_a_asignar__c = '';
        testProduct3.tax_status__c = 'none';
        testProduct3.Product_type__c = 'subscription';
        database.insert (testProduct3);
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Socios';
        Database.insert(pb);
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name = 'Socio participativo';
        Database.insert(pb1);
        
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'No Socio';
        Database.insert(pb2);
        
        PriceBookEntry pbeT = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbeT);
        
        PriceBookEntry pbeT2 = TestObjects.createPriceBookEntry(testProduct2);
        database.insert (pbeT2);
        
        PriceBookEntry pbeT3 = TestObjects.createPriceBookEntry(testProduct3);
        database.insert (pbeT3);
        
        List<PriceBookEntry>pbeList = new List<PriceBookEntry>();
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbeList.add(pbe);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(testProduct);
        pbe1.Pricebook2Id = pb1.Id;
        pbe1.IsActive = true;
        pbeList.add(pbe1);
        
        PriceBookEntry pbe2 = TestObjects.createPriceBookEntry(testProduct);
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.IsActive = true;
        pbeList.add(pbe2);
        
        PriceBookEntry pbe3 = TestObjects.createPriceBookEntry(testProduct2);
        pbe3.Pricebook2Id = pb.Id;
        pbe3.IsActive = true;
        pbeList.add(pbe3);
        
        PriceBookEntry pbe4 = TestObjects.createPriceBookEntry(testProduct2);
        pbe4.Pricebook2Id = pb1.Id;
        pbe4.IsActive = true;
        pbeList.add(pbe4);
        
        PriceBookEntry pbe5 = TestObjects.createPriceBookEntry(testProduct2);
        pbe5.Pricebook2Id = pb2.Id;
        pbe5.IsActive = true;
        pbeList.add(pbe5);
        
        PriceBookEntry pbe6 = TestObjects.createPriceBookEntry(testProduct3);
        pbe6.Pricebook2Id = pb.Id;
        pbe6.IsActive = true;
        pbeList.add(pbe6);
        
        PriceBookEntry pbe7 = TestObjects.createPriceBookEntry(testProduct3);
        pbe7.Pricebook2Id = pb1.Id;
        pbe7.IsActive = true;
        pbeList.add(pbe7);
        
        PriceBookEntry pbe8 = TestObjects.createPriceBookEntry(testProduct3);
        pbe8.Pricebook2Id = pb2.Id;
        pbe8.IsActive = true;
        pbeList.add(pbe8);
        database.insert (pbeList);
        
        Date hoy = Date.today();
        Account nuevaCuenta = TestObjects.createPersonalAccount();
        nuevaCuenta.LastName = 'Test1';
        nuevaCuenta.PersonEmail = 'test1@test.com';
        nuevaCuenta.Categor_a__c = 'Ple_dret';
        nuevaCuenta.Modalidad__c = 'Jóvenes 26-30';
        nuevaCuenta.Promociones__c = promo.Id;
        nuevaCuenta.Fecha_de_Caducidad__c = hoy.addMonths(10);
        nuevaCuenta.Fecha_renovaci_n_suscripci_n__c = hoy.addMonths(1);
        nuevaCuenta.Periodo_de_pago__c = 'Anual';
        nuevaCuenta.Tipo_de_documento__c = 'dni';
        nuevaCuenta.N_mero_de_Documento__pc = '79785074F';
        Database.insert(nuevaCuenta);
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        CrearCuotasBatch CrearCuotas = new CrearCuotasBatch();
        database.executeBatch(CrearCuotas,50);
        Test.stopTest();
    }
    
    @isTest
    public static void CuotasSinPromo() {
        Test.startTest();
        Maestro_de_Promociones__c promo = new Maestro_de_Promociones__c();
        promo.Desccuento__c = 50;
        promo.Name = 'Descuento 50%';
        Database.insert(promo);
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.Name = 'Test';
        testProduct.Role_to_assign__c = 'soci';
        testProduct.Modalidad_a_asignar__c = 'Jóvenes 26-30';
        testProduct.tax_status__c = 'taxable';
        testProduct.tax_class__c = 'zero';
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        Product2 testProduct2 = TestObjects.createProduct();
        testProduct2.Name = 'Suplemento';
        testProduct2.Product_type__c = 'subscription';
        database.insert (testProduct2);
        
        Product2 testProduct3 = TestObjects.createProduct();
        testProduct3.Name = 'Test participatiu';
        testProduct3.Role_to_assign__c = 'soci_participatiu';
        testProduct3.Modalidad_a_asignar__c = '';
        testProduct3.tax_status__c = 'none';
        testProduct3.Product_type__c = 'subscription';
        database.insert (testProduct3);
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Socios';
        Database.insert(pb);
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name = 'Socio participativo';
        Database.insert(pb1);
        
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'No Socio';
        Database.insert(pb2);
        
        PriceBookEntry pbeT = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbeT);
        
        PriceBookEntry pbeT2 = TestObjects.createPriceBookEntry(testProduct2);
        database.insert (pbeT2);
        
        PriceBookEntry pbeT3 = TestObjects.createPriceBookEntry(testProduct3);
        database.insert (pbeT3);
        
        List<PriceBookEntry>pbeList = new List<PriceBookEntry>();
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbeList.add(pbe);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(testProduct);
        pbe1.Pricebook2Id = pb1.Id;
        pbe1.IsActive = true;
        pbeList.add(pbe1);
        
        PriceBookEntry pbe2 = TestObjects.createPriceBookEntry(testProduct);
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.IsActive = true;
        pbeList.add(pbe2);
        
        PriceBookEntry pbe3 = TestObjects.createPriceBookEntry(testProduct2);
        pbe3.Pricebook2Id = pb.Id;
        pbe3.IsActive = true;
        pbeList.add(pbe3);
        
        PriceBookEntry pbe4 = TestObjects.createPriceBookEntry(testProduct2);
        pbe4.Pricebook2Id = pb1.Id;
        pbe4.IsActive = true;
        pbeList.add(pbe4);
        
        PriceBookEntry pbe5 = TestObjects.createPriceBookEntry(testProduct2);
        pbe5.Pricebook2Id = pb2.Id;
        pbe5.IsActive = true;
        pbeList.add(pbe5);
        
        PriceBookEntry pbe6 = TestObjects.createPriceBookEntry(testProduct3);
        pbe6.Pricebook2Id = pb.Id;
        pbe6.IsActive = true;
        pbeList.add(pbe6);
        
        PriceBookEntry pbe7 = TestObjects.createPriceBookEntry(testProduct3);
        pbe7.Pricebook2Id = pb1.Id;
        pbe7.IsActive = true;
        pbeList.add(pbe7);
        
        PriceBookEntry pbe8 = TestObjects.createPriceBookEntry(testProduct3);
        pbe8.Pricebook2Id = pb2.Id;
        pbe8.IsActive = true;
        pbeList.add(pbe8);
        database.insert (pbeList);
        
        Date hoy = Date.today();
        Account nuevaCuenta1 = TestObjects.createPersonalAccount();
        nuevaCuenta1.FirstName = 'Test2';
        nuevaCuenta1.LastName = 'Test2';
        nuevaCuenta1.PersonEmail = 'test2@test.com';
        nuevaCuenta1.Categor_a__c = 'Participatiu';
        nuevaCuenta1.Modalidad__c = null;
        nuevaCuenta1.Fecha_renovaci_n_suscripci_n__c = hoy.addMonths(1);
        nuevaCuenta1.Periodo_de_pago__c = 'Trimestral';
        nuevaCuenta1.Fecha_aplicaci_n_de_baja__c = hoy.addDays(10);
        nuevaCuenta1.Futura_categor_a_s_cio__c = 'Ple_dret';
        nuevaCuenta1.Futura_modalidad_del_socio__c = 'Jóvenes 26-30';
        nuevaCuenta1.Tipo_de_documento__c = 'dni';
        nuevaCuenta1.N_mero_de_Documento__pc = '79785074F';
        Database.insert(nuevaCuenta1);
        
        
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        CrearCuotasBatch CrearCuotas = new CrearCuotasBatch();
        database.executeBatch(CrearCuotas,50);
        Test.stopTest();
    }
    
    @isTest
    public static void Case3() {
        Test.startTest();
        Maestro_de_Promociones__c promo = new Maestro_de_Promociones__c();
        promo.Desccuento__c = 50;
        promo.Name = 'Descuento 50%';
        Database.insert(promo);
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.Name = 'Test';
        testProduct.Role_to_assign__c = 'soci';
        testProduct.Modalidad_a_asignar__c = 'Jóvenes 26-30';
        testProduct.tax_status__c = 'shipping';
        testProduct.tax_class__c = '';
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        Product2 testProduct2 = TestObjects.createProduct();
        testProduct2.Name = 'Suplemento';
        testProduct2.Product_type__c = 'subscription';
        database.insert (testProduct2);
        
        Product2 testProduct3 = TestObjects.createProduct();
        testProduct3.Name = 'Test participatiu';
        testProduct3.Role_to_assign__c = 'soci_participatiu';
        testProduct3.Modalidad_a_asignar__c = '';
        testProduct3.tax_status__c = 'none';
        testProduct3.Product_type__c = 'subscription';
        database.insert (testProduct3);
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Socios';
        Database.insert(pb);
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name = 'Socio participativo';
        Database.insert(pb1);
        
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'No Socio';
        Database.insert(pb2);
        
        PriceBookEntry pbeT = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbeT);
        
        PriceBookEntry pbeT2 = TestObjects.createPriceBookEntry(testProduct2);
        database.insert (pbeT2);
        
        PriceBookEntry pbeT3 = TestObjects.createPriceBookEntry(testProduct3);
        database.insert (pbeT3);
        
        List<PriceBookEntry>pbeList = new List<PriceBookEntry>();
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbeList.add(pbe);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(testProduct);
        pbe1.Pricebook2Id = pb1.Id;
        pbe1.IsActive = true;
        pbeList.add(pbe1);
        
        PriceBookEntry pbe2 = TestObjects.createPriceBookEntry(testProduct);
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.IsActive = true;
        pbeList.add(pbe2);
        
        PriceBookEntry pbe3 = TestObjects.createPriceBookEntry(testProduct2);
        pbe3.Pricebook2Id = pb.Id;
        pbe3.IsActive = true;
        pbeList.add(pbe3);
        
        PriceBookEntry pbe4 = TestObjects.createPriceBookEntry(testProduct2);
        pbe4.Pricebook2Id = pb1.Id;
        pbe4.IsActive = true;
        pbeList.add(pbe4);
        
        PriceBookEntry pbe5 = TestObjects.createPriceBookEntry(testProduct2);
        pbe5.Pricebook2Id = pb2.Id;
        pbe5.IsActive = true;
        pbeList.add(pbe5);
        
        PriceBookEntry pbe6 = TestObjects.createPriceBookEntry(testProduct3);
        pbe6.Pricebook2Id = pb.Id;
        pbe6.IsActive = true;
        pbeList.add(pbe6);
        
        PriceBookEntry pbe7 = TestObjects.createPriceBookEntry(testProduct3);
        pbe7.Pricebook2Id = pb1.Id;
        pbe7.IsActive = true;
        pbeList.add(pbe7);
        
        PriceBookEntry pbe8 = TestObjects.createPriceBookEntry(testProduct3);
        pbe8.Pricebook2Id = pb2.Id;
        pbe8.IsActive = true;
        pbeList.add(pbe8);
        database.insert (pbeList);
        
        Date hoy = Date.today();
        Account nuevaCuenta = TestObjects.createPersonalAccount();
        nuevaCuenta.LastName = 'Test1';
        nuevaCuenta.PersonEmail = 'test1@test.com';
        nuevaCuenta.Categor_a__c = 'Participatiu';
        nuevaCuenta.Modalidad__c = null;
        nuevaCuenta.Promociones__c = promo.Id;
        nuevaCuenta.Fecha_de_Caducidad__c = hoy.addMonths(10);
        nuevaCuenta.Fecha_renovaci_n_suscripci_n__c = hoy.addMonths(1);
        nuevaCuenta.Periodo_de_pago__c = '5';
        nuevaCuenta.Tipo_de_documento__c = 'dni';
        nuevaCuenta.N_mero_de_Documento__pc = '79785074F';
        Database.insert(nuevaCuenta);
        
        
        
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        CrearCuotasBatch CrearCuotas = new CrearCuotasBatch();
        database.executeBatch(CrearCuotas,50);
        Test.stopTest();
    }
    @isTest
    public static void Case4() {
        Test.startTest();
        Maestro_de_Promociones__c promo = new Maestro_de_Promociones__c();
        promo.Desccuento__c = 50;
        promo.Name = 'Descuento 50%';
        Database.insert(promo);
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.Name = 'Test';
        testProduct.Role_to_assign__c = 'soci';
        testProduct.Modalidad_a_asignar__c = 'Jóvenes 26-30';
        testProduct.tax_status__c = '';
        testProduct.tax_class__c = '';
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        Product2 testProduct2 = TestObjects.createProduct();
        testProduct2.Name = 'Suplemento';
        testProduct2.Product_type__c = 'subscription';
        database.insert (testProduct2);
        
        Product2 testProduct3 = TestObjects.createProduct();
        testProduct3.Name = 'Test participatiu';
        testProduct3.Role_to_assign__c = 'soci_participatiu';
        testProduct3.Modalidad_a_asignar__c = '';
        testProduct3.tax_status__c = 'none';
        testProduct3.Product_type__c = 'subscription';
        database.insert (testProduct3);
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Socios';
        Database.insert(pb);
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name = 'Socio participativo';
        Database.insert(pb1);
        
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'No Socio';
        Database.insert(pb2);
        
        PriceBookEntry pbeT = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbeT);
        
        PriceBookEntry pbeT2 = TestObjects.createPriceBookEntry(testProduct2);
        database.insert (pbeT2);
        
        PriceBookEntry pbeT3 = TestObjects.createPriceBookEntry(testProduct3);
        database.insert (pbeT3);
        
        List<PriceBookEntry>pbeList = new List<PriceBookEntry>();
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbeList.add(pbe);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(testProduct);
        pbe1.Pricebook2Id = pb1.Id;
        pbe1.IsActive = true;
        pbeList.add(pbe1);
        
        PriceBookEntry pbe2 = TestObjects.createPriceBookEntry(testProduct);
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.IsActive = true;
        pbeList.add(pbe2);
        
        PriceBookEntry pbe3 = TestObjects.createPriceBookEntry(testProduct2);
        pbe3.Pricebook2Id = pb.Id;
        pbe3.IsActive = true;
        pbeList.add(pbe3);
        
        PriceBookEntry pbe4 = TestObjects.createPriceBookEntry(testProduct2);
        pbe4.Pricebook2Id = pb1.Id;
        pbe4.IsActive = true;
        pbeList.add(pbe4);
        
        PriceBookEntry pbe5 = TestObjects.createPriceBookEntry(testProduct2);
        pbe5.Pricebook2Id = pb2.Id;
        pbe5.IsActive = true;
        pbeList.add(pbe5);
        
        PriceBookEntry pbe6 = TestObjects.createPriceBookEntry(testProduct3);
        pbe6.Pricebook2Id = pb.Id;
        pbe6.IsActive = true;
        pbeList.add(pbe6);
        
        PriceBookEntry pbe7 = TestObjects.createPriceBookEntry(testProduct3);
        pbe7.Pricebook2Id = pb1.Id;
        pbe7.IsActive = true;
        pbeList.add(pbe7);
        
        PriceBookEntry pbe8 = TestObjects.createPriceBookEntry(testProduct3);
        pbe8.Pricebook2Id = pb2.Id;
        pbe8.IsActive = true;
        pbeList.add(pbe8);
        database.insert (pbeList);
        
        Date hoy = Date.today();
        Account nuevaCuenta = TestObjects.createPersonalAccount();
        nuevaCuenta.LastName = 'Test1';
        nuevaCuenta.PersonEmail = 'test1@test.com';
        nuevaCuenta.Categor_a__c = 'Ple_dret';
        nuevaCuenta.Modalidad__c = 'Jóvenes 26-30';
        nuevaCuenta.Promociones__c = promo.Id;
        nuevaCuenta.Fecha_de_Caducidad__c = hoy.addMonths(10);
        nuevaCuenta.Fecha_renovaci_n_suscripci_n__c = hoy.addMonths(1);
        nuevaCuenta.Periodo_de_pago__c = '5';
        nuevaCuenta.Tipo_de_documento__c = 'dni';
        nuevaCuenta.N_mero_de_Documento__pc = '79785074F';
        Database.insert(nuevaCuenta);
        
        
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        CrearCuotasBatch CrearCuotas = new CrearCuotasBatch();
        database.executeBatch(CrearCuotas,50);
        Test.stopTest();
    }
    
    /*
    
    @isTest
    public static void case5() {
        Maestro_de_Promociones__c promo = new Maestro_de_Promociones__c();
        promo.Desccuento__c = 50;
        promo.Name = 'Descuento 50%';
        Database.insert(promo);
        
        Product2 testProduct = TestObjects.createProduct();
        testProduct.Name = 'Test';
        testProduct.Role_to_assign__c = 'soci';
        testProduct.Modalidad_a_asignar__c = 'Jóvenes 26-30';
        testProduct.tax_status__c = '';
        testProduct.tax_class__c = '';
        testProduct.Product_type__c = 'subscription';
        database.insert (testProduct);
        
        Product2 testProduct2 = TestObjects.createProduct();
        testProduct2.Name = 'Suplemento';
        testProduct2.Product_type__c = 'subscription';
        database.insert (testProduct2);
        
        Product2 testProduct3 = TestObjects.createProduct();
        testProduct3.Name = 'Test participatiu';
        testProduct3.Role_to_assign__c = 'soci_participatiu';
        testProduct3.Modalidad_a_asignar__c = '';
        testProduct3.tax_status__c = 'none';
        testProduct3.Product_type__c = 'subscription';
        database.insert (testProduct3);
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Socios';
        Database.insert(pb);
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name = 'Socio participativo';
        Database.insert(pb1);
        
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'No Socio';
        Database.insert(pb2);
        
        PriceBookEntry pbeT = TestObjects.createPriceBookEntry(testProduct);
        database.insert (pbeT);
        
        PriceBookEntry pbeT2 = TestObjects.createPriceBookEntry(testProduct2);
        database.insert (pbeT2);
        
        PriceBookEntry pbeT3 = TestObjects.createPriceBookEntry(testProduct3);
        database.insert (pbeT3);
        
        List<PriceBookEntry>pbeList = new List<PriceBookEntry>();
        PriceBookEntry pbe = TestObjects.createPriceBookEntry(testProduct);
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbeList.add(pbe);
        
        PriceBookEntry pbe1 = TestObjects.createPriceBookEntry(testProduct);
        pbe1.Pricebook2Id = pb1.Id;
        pbe1.IsActive = true;
        pbeList.add(pbe1);
        
        PriceBookEntry pbe2 = TestObjects.createPriceBookEntry(testProduct);
        pbe2.Pricebook2Id = pb2.Id;
        pbe2.IsActive = true;
        pbeList.add(pbe2);
        
        PriceBookEntry pbe3 = TestObjects.createPriceBookEntry(testProduct2);
        pbe3.Pricebook2Id = pb.Id;
        pbe3.IsActive = true;
        pbeList.add(pbe3);
        
        PriceBookEntry pbe4 = TestObjects.createPriceBookEntry(testProduct2);
        pbe4.Pricebook2Id = pb1.Id;
        pbe4.IsActive = true;
        pbeList.add(pbe4);
        
        PriceBookEntry pbe5 = TestObjects.createPriceBookEntry(testProduct2);
        pbe5.Pricebook2Id = pb2.Id;
        pbe5.IsActive = true;
        pbeList.add(pbe5);
        
        PriceBookEntry pbe6 = TestObjects.createPriceBookEntry(testProduct3);
        pbe6.Pricebook2Id = pb.Id;
        pbe6.IsActive = true;
        pbeList.add(pbe6);
        
        PriceBookEntry pbe7 = TestObjects.createPriceBookEntry(testProduct3);
        pbe7.Pricebook2Id = pb1.Id;
        pbe7.IsActive = true;
        pbeList.add(pbe7);
        
        PriceBookEntry pbe8 = TestObjects.createPriceBookEntry(testProduct3);
        pbe8.Pricebook2Id = pb2.Id;
        pbe8.IsActive = true;
        pbeList.add(pbe8);
        database.insert (pbeList);
        
        Date hoy = Date.today();
        Date baja = date.newInstance(1900, 1, 1);
        Account nuevaCuenta = TestObjects.createPersonalAccount();
        nuevaCuenta.LastName = 'Test1';
        nuevaCuenta.PersonEmail = 'test1@test.com';
        nuevaCuenta.Categor_a__c = 'Ple_dret';
        nuevaCuenta.Modalidad__c = 'Jóvenes 26-30';
        nuevaCuenta.Promociones__c = promo.Id;
        nuevaCuenta.Fecha_de_Caducidad__c = hoy.addMonths(10);
        nuevaCuenta.Fecha_renovaci_n_suscripci_n__c = hoy.addMonths(1);
        nuevaCuenta.Fecha_aplicaci_n_de_baja__c = baja;
        system.debug('FECHA BAJA: ' + baja + 'FECHA RENOV: ' +hoy);
        nuevaCuenta.Periodo_de_pago__c = '5';
        nuevaCuenta.Tipo_de_documento__c = 'dni';
        nuevaCuenta.N_mero_de_Documento__pc = '79785074F';
        Database.insert(nuevaCuenta);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BirchmanGeneralAPIMockImpl());
        CrearCuotasBatch CrearCuotas = new CrearCuotasBatch();
        database.executeBatch(CrearCuotas,50);
        Test.stopTest();
    }

*/

    
}