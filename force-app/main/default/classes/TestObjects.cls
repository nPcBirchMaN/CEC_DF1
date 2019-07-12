@isTest
public class TestObjects {
    public static void initializeObjects() {    
        Pricebook2 pb = new Pricebook2();
        pb.id = Test.getStandardPricebookId();
        pb.Name = 'Standard Price Book';
        update pb;
        
        Product2 pro = new Product2();
        pro.Name = 'Quota anual Soci Infant 6-13 CEC';
        pro.Role_to_assign__c = 'Menor';
        pro.Modalidad_a_asignar__c = 'Niños 6-13';
        pro.IsActive = True;
        pro.Product_type__c = 'subscription';
		insert pro;
        
		Product2 pro2 = new Product2();
        pro2.Name = 'Quota anual Soci Vitalici CEC';
        pro2.Role_to_assign__c = 'soci';
        pro2.Modalidad_a_asignar__c = 'Vitalicio';
        pro2.IsActive = True;
        pro2.Product_type__c = 'subscription';
        insert pro2;
        
        Product2 pro3 = new Product2();
        pro3.Name = 'Quota anual Soci Participatiu CEC';
        pro3.Role_to_assign__c = 'soci_participatiu';
        pro3.Modalidad_a_asignar__c = null;
        pro3.IsActive = True;
        pro3.Product_type__c = 'subscription';
        insert pro3;
        
        Product2 pro5 = new Product2();
        pro5.Name = 'Quota anual Soci Participatiu CEC';
        pro5.Role_to_assign__c = 'soci';
        pro5.Modalidad_a_asignar__c = null;
        pro5.IsActive = True;
        pro5.Product_type__c = 'subscription';
        insert pro5;
        
        Id pbId = Test.getStandardPricebookId();
        
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.IsActive = true;
        pbe1.Pricebook2Id = pbId;
        pbe1.Product2Id = pro.id;
        pbe1.UnitPrice = 18;
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.IsActive = true;
        pbe2.Pricebook2Id = pbId;
        pbe2.Product2Id = pro2.id;
        pbe2.UnitPrice = 0;
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.IsActive = true;
        pbe3.Pricebook2Id = pbId;
        pbe3.Product2Id = pro3.id;
        pbe3.UnitPrice = 25;
        insert pbe3;
        
        Product2 pro4 = new Product2();
        pro4.Name = 'Matrícula';
        pro4.IsActive = True;
        insert pro4;
        
        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.IsActive = true;
        pbe4.Pricebook2Id = pbId;
        pbe4.Product2Id = pro4.id;
        pbe4.UnitPrice = 20;        
        insert pbe4;
        
        PricebookEntry pbe5 = new PricebookEntry();
        pbe5.IsActive = true;
        pbe5.Pricebook2Id = pbId;
        pbe5.Product2Id = pro5.id;
        pbe5.UnitPrice = 20;        
        insert pbe5;
        
        
        Product2 pro7 = new Product2();
        pro7.Name = 'Quota anual Soci Sènior CEC';
        pro7.Role_to_assign__c = 'soci';
        pro7.Modalidad_a_asignar__c = 'Seniors';
        pro7.IsActive = True;
        pro7.Product_type__c = 'subscription';
		insert pro7;
        
        Product2 pro8 = new Product2();
        pro8.Name = 'Quota anual Soci Col·lectiu CEC';
        pro8.Role_to_assign__c = 'soci';
        pro8.Modalidad_a_asignar__c = 'Colectivo';
        pro8.IsActive = True;
        pro8.Product_type__c = 'subscription';
		insert pro8;
        
        Product2 pro9 = new Product2();
        pro9.Name = 'Quota anual Soci Sènior Federat CEC';
        pro9.Role_to_assign__c = 'soci';
        pro9.Modalidad_a_asignar__c = 'Seniors federados';
        pro9.IsActive = True;
        pro9.Product_type__c = 'subscription';
		insert pro9;
        
        Product2 pro10 = new Product2();
        pro10.Name = 'Quota anual Soci Protector CEC';
        pro10.Role_to_assign__c = 'soci';
        pro10.Modalidad_a_asignar__c = 'Protector';
        pro10.IsActive = True;
        pro10.Product_type__c = 'subscription';
		insert pro10;
        
        Product2 pro11 = new Product2();
        pro11.Name = 'Quota anual Soci Protector Federat CEC';
        pro11.Role_to_assign__c = 'soci';
        pro11.Modalidad_a_asignar__c = 'Protector federados';
        pro11.IsActive = True;
        pro11.Product_type__c = 'subscription';
		insert pro11;
        
        Product2 pro12 = new Product2();
        pro12.Name = 'Quota anual Soci Veterà CEC';
        pro12.Role_to_assign__c = 'soci';
        pro12.Modalidad_a_asignar__c = 'Veteranos';
        pro12.IsActive = True;
        pro12.Product_type__c = 'subscription';
		insert pro12;
        
        Product2 pro13 = new Product2();
        pro13.Name = 'Quota anual Soci Júnior 14-17 CEC';
        pro13.Role_to_assign__c = 'Menor';
        pro13.Modalidad_a_asignar__c = 'Juniors 14-17';
        pro13.IsActive = True;
        pro13.Product_type__c = 'subscription';
		insert pro13;
        
        Product2 pro14 = new Product2();
        pro14.Name = 'Quota anual Soci Infant 0-5 CEC';
        pro14.Role_to_assign__c = 'Menor';
        pro14.Modalidad_a_asignar__c = 'Niños 0-5';
        pro14.IsActive = True;
        pro14.Product_type__c = 'subscription';
		insert pro14;
        
        Product2 pro15 = new Product2();
        pro15.Name = 'Quota anual Soci Familiar CEC';
        pro15.Role_to_assign__c = 'soci';
        pro15.Modalidad_a_asignar__c = 'Familiar';
        pro15.IsActive = True;
        pro15.Product_type__c = 'subscription';
		insert pro15;
        
        Product2 pro16 = new Product2();
        pro16.Name = 'Quota anual Soci Familiar Federat CEC';
        pro16.Role_to_assign__c = 'soci';
        pro16.Modalidad_a_asignar__c = 'Familiar federado';
        pro16.IsActive = True;
        pro16.Product_type__c = 'subscription';
		insert pro16;
        
        Product2 pro17 = new Product2();
        pro17.Name = 'Quota anual Soci Jove 18-25 Federat CEC';
        pro17.Role_to_assign__c = 'soci';
        pro17.Modalidad_a_asignar__c = 'Jóvenes 18-25 federados';
        pro17.IsActive = True;
        pro17.Product_type__c = 'subscription';
		insert pro17;
        
        Product2 pro18 = new Product2();
        pro18.Name = 'Quota anual Soci Jove 26-30 CEC';
        pro18.Role_to_assign__c = 'soci';
        pro18.Modalidad_a_asignar__c = 'Jóvenes 26-30';
        pro18.IsActive = True;
        pro18.Product_type__c = 'subscription';
		insert pro18;
        
        Product2 pro19 = new Product2();
        pro19.Name = 'Quota anual Soci Col·lectiu Federat CEC';
        pro19.Role_to_assign__c = 'soci';
        pro19.Modalidad_a_asignar__c = 'Colectivo federado';
        pro19.IsActive = True;
        pro19.Product_type__c = 'subscription';
		insert pro19;
        
        Product2 pro20 = new Product2();
        pro20.Name = 'Quota anual Soci Jove 18-25 CEC';
        pro20.Role_to_assign__c = 'soci';
        pro20.Modalidad_a_asignar__c = 'Jóvenes 18-25';
        pro20.IsActive = True;
        pro20.Product_type__c = 'subscription';
		insert pro20;
        
        Product2 pro21 = new Product2();
        pro21.Name = 'Quota anual Soci Jove 26-30 Federat CEC';
        pro21.Role_to_assign__c = 'soci';
        pro21.Modalidad_a_asignar__c = 'Jóvenes 26-30 federados';
        pro21.IsActive = True;
        pro21.Product_type__c = 'subscription';
		insert pro21;
        
        Product2 pro22 = new Product2();
        pro22.Name = 'Quota anual Soci Veterà Federat CEC';
        pro22.Role_to_assign__c = 'soci';
        pro22.Modalidad_a_asignar__c = 'Veteranos federados';
        pro22.IsActive = True;
        pro22.Product_type__c = 'subscription';
		insert pro22;
        
        PricebookEntry pbe7 = new PricebookEntry();
        pbe7.IsActive = true;
        pbe7.Pricebook2Id = pbId;
        pbe7.Product2Id = pro7.id;
        pbe7.UnitPrice = 144;
        insert pbe7;
        
        PricebookEntry pbe8 = new PricebookEntry();
        pbe8.IsActive = true;
        pbe8.Pricebook2Id = pbId;
        pbe8.Product2Id = pro8.id;
        pbe8.UnitPrice = 100;
        insert pbe8;
        
        PricebookEntry pbe9 = new PricebookEntry();
        pbe9.IsActive = true;
        pbe9.Pricebook2Id = pbId;
        pbe9.Product2Id = pro9.id;
        pbe9.UnitPrice = 144;
        insert pbe9;
        
        PricebookEntry pbe10 = new PricebookEntry();
        pbe10.IsActive = true;
        pbe10.Pricebook2Id = pbId;
        pbe10.Product2Id = pro10.id;
        pbe10.UnitPrice = 200;
        insert pbe10;
        
        PricebookEntry pbe11 = new PricebookEntry();
        pbe11.IsActive = true;
        pbe11.Pricebook2Id = pbId;
        pbe11.Product2Id = pro11.id;
        pbe11.UnitPrice = 200;
        insert pbe11;
        
        PricebookEntry pbe12 = new PricebookEntry();
        pbe12.IsActive = true;
        pbe12.Pricebook2Id = pbId;
        pbe12.Product2Id = pro12.id;
        pbe12.UnitPrice = 136;
        insert pbe12;
        
        PricebookEntry pbe13 = new PricebookEntry();
        pbe13.IsActive = true;
        pbe13.Pricebook2Id = pbId;
        pbe13.Product2Id = pro13.id;
        pbe13.UnitPrice = 25;
        insert pbe13;
        
        PricebookEntry pbe14 = new PricebookEntry();
        pbe14.IsActive = true;
        pbe14.Pricebook2Id = pbId;
        pbe14.Product2Id = pro14.id;
        pbe14.UnitPrice = 14;
        insert pbe14;
        
        PricebookEntry pbe15 = new PricebookEntry();
        pbe15.IsActive = true;
        pbe15.Pricebook2Id = pbId;
        pbe15.Product2Id = pro15.id;
        pbe15.UnitPrice = 80;
        insert pbe15;
        
        PricebookEntry pbe16 = new PricebookEntry();
        pbe16.IsActive = true;
        pbe16.Pricebook2Id = pbId;
        pbe16.Product2Id = pro16.id;
        pbe16.UnitPrice = 80;
        insert pbe16;
        
        PricebookEntry pbe17 = new PricebookEntry();
        pbe17.IsActive = true;
        pbe17.Pricebook2Id = pbId;
        pbe17.Product2Id = pro17.id;
        pbe17.UnitPrice = 62;
        insert pbe17;
        
        PricebookEntry pbe18 = new PricebookEntry();
        pbe18.IsActive = true;
        pbe18.Pricebook2Id = pbId;
        pbe18.Product2Id = pro18.id;
        pbe18.UnitPrice = 82;
        insert pbe18;
        
        PricebookEntry pbe19 = new PricebookEntry();
        pbe19.IsActive = true;
        pbe19.Pricebook2Id = pbId;
        pbe19.Product2Id = pro19.id;
        pbe19.UnitPrice = 100;
        insert pbe19;
        
        PricebookEntry pbe20 = new PricebookEntry();
        pbe20.IsActive = true;
        pbe20.Pricebook2Id = pbId;
        pbe20.Product2Id = pro20.id;
        pbe20.UnitPrice = 62;
        insert pbe20;
        
        PricebookEntry pbe21 = new PricebookEntry();
        pbe21.IsActive = true;
        pbe21.Pricebook2Id = pbId;
        pbe21.Product2Id = pro21.id;
        pbe21.UnitPrice = 82;
        insert pbe21;
        
        PricebookEntry pbe22 = new PricebookEntry();
        pbe22.IsActive = true;
        pbe22.Pricebook2Id = pbId;
        pbe22.Product2Id = pro22.id;
        pbe22.UnitPrice = 136;
        insert pbe22;
    }
    
    public static Account createEmpresaAccount(RecordType rt) {
        Account acc = new Account();
        acc.N_mero_de_CIF__c = 'U1599837J';
        acc.RecordTypeId = rt.id;
        acc.Name = 'Test Cuenta Empresa';
        return acc;
    }
    
    public static Account createPersonalAccount() {
        Account acc = new Account();
        acc.LastName = 'Lastname Acc Test';
        acc.Tipo_de_documento__c = 'dni';
        acc.N_mero_de_Documento__pc = '79785079F';
        acc.Categor_a__c = 'Ple_dret';
        //acc.Modalidad__c = 'Familiar';
        acc.PersonEmail = 'Test@test.com';
        return acc;
    }
    
    public static Contact createContact() {
        Contact con = new Contact();
        con.Lastname = 'Test Contact';
        return con;
    }
    
    public static Opportunity createOpportunity() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = 'Nueva';
        opp.CloseDate = Date.today() + 31;
        return opp;
    }
    
    public static Order createOrder(Account acc) {
        Order ord = new Order();
        ord.accountid = acc.id;
        ord.EffectiveDate = Date.today();
        ord.Status = 'Borrador';
        ord.Pricebook2Id = Test.getStandardPricebookId();
        return ord;
    }
    
    public static Product2 createProduct() {
        Product2 pro = new Product2();
        pro.Name = 'Producto Test' + Math.random();
        pro.IsActive = True;
        return pro;
    }
    
    public static Etapas_socio__c createEtapasSocio(Account acc){
        Etapas_socio__c eta = new Etapas_socio__c();
        eta.Cuenta__c = acc.id;
        return eta;
    }
    
    public static Empleados__c createEmpleados() {
        Empleados__c emp = new Empleados__c();
        emp.Name = 'Empleado';
        emp.Email__c = 'estoesunempleadodetest@test.com';
        emp.Apellidos__c = 'Test';
        return emp;
    }
	
    public static OrderItem createOrderItem(Order ord, PriceBookEntry pbe, Product2 pro) {
        OrderItem oItem = new OrderItem();
        oItem.PricebookEntryId = pbe.id;
        oItem.Quantity = 10;
        oItem.OrderId = ord.Id;
        oItem.Product2Id = pro.id;
        oItem.UnitPrice = 10;
        return oItem;
    }
    
    public static PriceBookEntry createPriceBookEntry(Product2 pro) {
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.IsActive = True;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = pro.id;
        pbe.UnitPrice = 10;
        pbe.UseStandardPrice = False;
        return pbe;
    }
    
    public static Alquiler_Material__c createAlquilerMaterial() {
        Alquiler_Material__c am = new Alquiler_Material__c();
        am.devuelto__c = true;
        am.Material__c = 'sky';
        am.Fecha_Fin__c = date.today()+1;
        return am;
    }
    
    public static Vencimiento__c createVencimientos(Factura__c factura) {
        Vencimiento__c vencimiento = new Vencimiento__c();
        vencimiento.Factura__c = factura.Id;
        vencimiento.Nombre_de_la_factura__c = factura.Name;
        vencimiento.N_mero_de_Factura__c = factura.N_mero_de_factura__c;
        vencimiento.Tipo_de_factura__c = 'Definitiva';
        vencimiento.Tipo_de_Pago__c = factura.Tipo_de_pago__c;
        vencimiento.Inicio_de_Facturaci_n__c = factura.Inicio_periodo_facturaci_n__c;
        vencimiento.Importe_de_factura__c = factura.Importe_total_factura__c;
        vencimiento.Importe_Total__c = factura.Importe_total_factura__c;
        vencimiento.Cobrada__c = factura.Cobrada__c;
        vencimiento.Impagada__c = factura.Impagada__c;
        return vencimiento;
    }
    
     public static Factura__c createFacturaOrder(Order pedido) {
        Factura__c factura = new Factura__c ();
        factura.Name = 'Pedido '+ pedido.OrderNumber;
        factura.Cliente__c = pedido.AccountId;
        factura.Fecha_emisi_n_factura__c = Date.today();
        factura.Tipo_de_pago__c = pedido.Tipo_de_pago__c;
        factura.Tipo_de_Factura__c='Definitiva';
        factura.Id_de_Pedido__c= pedido.id;
        return factura;
    }
    
    public static L_neas_de_factura__c createLineasFacturaOrder(Factura__c factura, OrderItem prod) {
        L_neas_de_factura__c lineaNueva = new L_neas_de_factura__c ();
        lineaNueva.Factura__c = factura.Id;
        lineaNueva.Producto__c = prod.Product2Id;
        lineaNueva.Cantidad__c = prod.Quantity;
        lineaNueva.Precio_unitario__c = prod.UnitPrice;
        return lineaNueva;
    }
    
    public static Factura__c createFacturaOpportunity(Opportunity opp) {
        Factura__c factura = new Factura__c ();
        factura.Name = 'Oportunidad '+ opp.N_Oportunidad__c;
        factura.Cliente__c = opp.AccountId;
        factura.Fecha_emisi_n_factura__c = Date.today();
        factura.Tipo_de_pago__c = opp.Tipo_de_pago__c;
        factura.Tipo_de_Factura__c='Definitiva';
        factura.Id_de_Oportunidad__c = opp.id;
        return factura;
    }
    
    public static L_neas_de_factura__c createLineasFacturaOpportunity(Factura__c factura, OpportunityLineItem oppLine) {
        L_neas_de_factura__c lineaNueva = new L_neas_de_factura__c ();
        lineaNueva.Factura__c = factura.Id;
        lineaNueva.Producto__c = oppLine.Product2Id;
        lineaNueva.Cantidad__c = oppLine.Quantity;
        lineaNueva.Precio_unitario__c = oppLine.UnitPrice;
        return lineaNueva;
    }
    
    public static OpportunityLineItem createOpportunityItem(Opportunity opp, PriceBookEntry pbe, Product2 pro) {
        OpportunityLineItem oItem = new OpportunityLineItem();
        oItem.PricebookEntryId = pbe.id;
        oItem.Quantity = 10;
        oItem.OpportunityId = opp.Id;
        oItem.Product2Id = pro.id;
        oItem.UnitPrice = 10;
        return oItem;
    }
}