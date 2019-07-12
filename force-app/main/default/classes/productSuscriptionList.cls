global class productSuscriptionList {
   
    public static Map<String, Product2> getProductoModalidad() {
        Map<String, Product2> productoModalidad = new Map<String, Product2>();
		List<String> listaModalidades = getListaModalidades();
        List<Product2> productosSuscripcion = productSuscriptionList();
        
        //System.debug('Mapa modalidad - producto');
        for (String modalidad : listaModalidades) {
            for (Product2 producto : productosSuscripcion) {
                if (producto.Modalidad_a_asignar__c == modalidad) {
                    //System.debug('Modalidad: '+modalidad+'; Producto: '+producto.Id);
                    productoModalidad.put(modalidad, producto);
                } else if (producto.Role_to_assign__c == 'soci_participatiu' && producto.Role_to_assign__c == modalidad) {
                    //System.debug('Modalidad: '+modalidad+'; Producto: '+producto.Id);
                    productoModalidad.put(modalidad, producto); 
                }
            }
        }
        return productoModalidad;
    }
    
     public static List<Product2> productSuscriptionList() {
        List<Product2> productosSuscripcion = [Select Id, Name, Role_to_assign__c, Modalidad_a_asignar__c,tax_status__c,tax_class__c, 
                                               (Select UnitPrice, Pricebook2.Name From PricebookEntries Where Pricebook2.Name != 'Standard Price Book')
                                               From Product2 Where Product_type__c = 'subscription' and Role_to_assign__c != null And isActive = true];
        return productosSuscripcion;
    }
    
    public static List<String> getListaModalidades(){
        List<String> listaModalidades= new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Modalidad__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            listaModalidades.add(pickListVal.getValue());
        }
        listaModalidades.add('soci_participatiu');
        return listaModalidades;
    }
    
    public static List<Factura__c> getFacturasCreadas(Set<Id> SetIdFacturas) {
        List<Factura__c> facturasCreadas = [Select Id, Name, N_mero_de_factura__c, Tipo_de_pago__c, Tipo_de_Factura__c, Inicio_periodo_facturaci_n__c, Importe_total_factura__c, Cobrada__c, Impagada__c, 
                                            Fecha_vencimiento__c, Fecha_de_pago__c, Fecha_emisi_n_factura__c, Periodo_de_pago__c, Cliente__r.Id_Cliente__c, Cliente__r.Fecha_alta_original__c,
                                            Cliente__r.CreatedDate, Cliente__c, Cliente__r.IBAN__c, Cliente__r.BIC_SWIFT__c
                                            From Factura__c Where Id =: SetIdFacturas And Periodo_de_pago__c != null];
        return facturasCreadas;
    }
    
    public static Product2 getSuplemento() {
        Product2 productosSuplemento = [Select Id, Name, Role_to_assign__c, Modalidad_a_asignar__c,tax_status__c,tax_class__c, 
                                               (Select UnitPrice, Pricebook2.Name From PricebookEntries Where Pricebook2.Name != 'Standard Price Book')
                                               From Product2 Where Product_type__c = 'subscription' and Name = 'Suplemento' And isActive = true];
        return productosSuplemento;
    }
    
    public static List<Factura__c> getCuentasConFacturasDomiciliadas(Set<Id> SetIdCuentas) {
        List<Factura__c> facturas = [Select Id, Cliente__c From Factura__c Where Tipo_de_pago__c = 'Domiciliación bancaria' And Cliente__c = : SetIdCuentas];
        return facturas;
    }
    
    public static Product2 getRevista(String nombreRevista) {
        Product2 productoRevista = [Select Id, Name, Role_to_assign__c, Modalidad_a_asignar__c,tax_status__c,tax_class__c, 
                                               (Select UnitPrice, Pricebook2.Name From PricebookEntries Where Pricebook2.Name = 'Standard Price Book')
                                               From Product2 Where Product_type__c = 'subscription' and Name =:nombreRevista  And isActive = true];
        return productoRevista;
    }
}