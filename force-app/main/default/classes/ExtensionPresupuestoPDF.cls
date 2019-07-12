public class ExtensionPresupuestoPDF {
    public class bImponibleEnvelope {
        public double bimponible {get; set;}
        public string iva {get; set;}
        public Decimal total {get; set;}
        public boolean items {get; set;}
        public string formated_bimponible {get; set;}
        public string formated_total {get; set;}
        public bImponibleEnvelope() {
            bImponible = 0.0;
            total = 0.0;
            items = false;
        }
    }
    
    public class oliEnvelope {
        public String Name {get; set;}
        public String quantity {get; set;}
        public String tax {get; set;}
        public String unitPrice {get; set;}
        public String total {get; set;}
    }
    // Private unstored attrs.
    private transient ApexPages.StandardController ctrl;
    private transient Id recordId;
    
    // public attrs.
    public Date presupuestoDate {get; private set;}
    public List<OpportunityLineItem> oliList {get; private set;}
    public List<oliEnvelope> oliEnvelopeList {get; private set;}
    public Double baseImponible {get; private set;}
    public Double total {get; private set;}
    Public Map<String, bImponibleEnvelope> bMap {get; set;}
    Public List<bImponibleEnvelope> orderedBIList {get; set;}
    Public String formated_total {get; set;}
    Public String formated_baseImponible {get; set;}
    
    
    public ExtensionPresupuestoPDF(ApexPages.StandardController ctrl) {
        this.ctrl = ctrl;
        this.recordId = ctrl.getRecord().id;
        this.presupuestoDate = Date.today();
        this.bMap = new Map<String, bImponibleEnvelope>();
        this.oliList = [SELECT id, Product2.Name, toLabel(Product2.tax_class__c), Quantity, UnitPrice, TotalPrice FROM OpportunityLineItem WHERE OpportunityId =: this.recordId];
        this.oliEnvelopeList = new List<oliEnvelope>();
        
        // Initialize Opp List 
        initOpportunityLineItemList();
        this.baseImponible = 0.0;
        this.total = 0.0;
        // Initialize products map
        initBImponibleMap();
        // Fill products map
        fillBImponibleMap();
        // Order List
        orderBIList();
    }
    
    private void initOpportunityLineItemList() {
        oliEnvelope e;
        
        for(OpportunityLineItem oli: oliList) {
            e = new oliEnvelope();
            e.Name = oli.Product2.Name;
            if (oli.Product2 != null && oli.Product2.tax_class__c != null) {
                Decimal tax = Decimal.valueOf(oli.Product2.tax_class__c.left(oli.Product2.tax_class__c.indexOf('%'))) / 100 + 1;
                e.quantity = format(oli.quantity, 2);
                
                Decimal up = oli.UnitPrice / tax;
                e.UnitPrice = format(up, 2);
                Decimal total = oli.TotalPrice / tax;
                
                e.total = format(total,2);
                e.tax = (oli.Product2.tax_class__c == null) ? '0' : oli.Product2.tax_class__c.left(oli.Product2.tax_class__c.indexOf('%'));
            }
            oliEnvelopeList.add(e);
        }
    }
    
    private void initBImponibleMap() {
        // Retrieve picklist values from TAX_CLASS__C
        Schema.DescribeFieldResult fieldResult = Product2.tax_class__c.getDescribe();
        List<Schema.PicklistEntry> pleList = fieldResult.getPicklistValues();
        
        // Generate for every picklist entry a bImponibleEnvelope.
        for(Schema.PicklistEntry ple: pleList) {
            // Get picklist label & value
            String label = ple.getLabel();
            String val = ple.getLabel();
            // Initialize envelope
            bImponibleEnvelope bi = new bImponibleEnvelope();
            // Extract TAX % as string value
            val = val.left(val.indexOf('%'));
            // Store in envelope
            bi.iva = val;
            // Save envelope
            bMap.put(label, bi);
        }
    }
    
    private void fillBImponibleMap() {
        // For every opportunity Line Item, calculate its base imponible and add it to general baseImponible.
        for(OpportunityLineItem oli: oliList) {
            if(oli.TotalPrice <> null && oli.TotalPrice <> 0) {
                // Get product Tax class
                String tax = (!String.isEmpty(oli.Product2.tax_class__c)) ? oli.Product2.tax_class__c : '0% Tasa Cero';
                // Retrieve suitable baseImponible envelope
                bImponibleEnvelope bi = bMap.get(tax);
                // Calculate iva in format 1.xx
                Double iva = 1+(Double.valueOf(bi.iva)/100);
                // Calculate bImponible without TAX
                bi.bimponible += ((Decimal)(oli.Quantity * oli.UnitPrice) / iva).setScale(2);
                bi.items = true;
                // Calculate general baseImponible without TAX
                baseImponible += ((Decimal)(oli.Quantity * oli.UnitPrice) / iva).setScale(2);
            }
        }
        
        // Initialize total as baseImponible to print total with tax added.
        total = baseImponible;
        // For every envelope, calculate its total.
        for(bImponibleEnvelope bi: bMap.values()) {
            if(!String.isEmpty(bi.iva)) {
                // Calculate iva in format 0.XX
                Double iva = Double.valueOf(bi.iva)/100;
                bi.total = bi.bimponible;
                if (bi.iva <> '0')
                    // If tax is different than 0, calculate with TAX.
                    bi.total = ((Decimal)bi.total.setScale(2, RoundingMode.HALF_DOWN) * iva).setScale(2);
                else
                    // Else, set total tax value to 0.
                    bi.total = 0;
                // Update total value.
                total += ((Decimal)bi.total).setScale(2);    
            }
            
        }
    }
    private void orderBIList() {
        orderedBIList = new List<bImponibleEnvelope>();
        // Order add
        orderedBIList.add(bMap.get('0% Tasa Cero'));
        orderedBIList.add(bMap.get('4% Tasa super reducida'));
        orderedBIList.add(bMap.get('10% Tasa baja'));
        orderedBIList.add(bMap.get('21% Estándar'));
        
        // Format numbers 
        for(bImponibleEnvelope b: orderedBIList) {
            b.formated_bimponible = format(b.bimponible, 2);
            b.formated_total = format(b.total, 2);
        }
        
        formated_total = format(total, 2);
        formated_baseImponible = format(baseImponible, 2);
    }
    
    public static String format(Decimal d, Integer places) {
        
        if (d != null) {
            
            // Round first
            Decimal dd = d.setScale(places);
            
            // Format to get thousand separators
            String w = dd.longValue().format();
            
            if (places != 0) {
                
                if (dd < 0) dd = -dd;
                Integer multiplier = Integer.valueOf(Math.pow(10, places));
                
                // For example 0.0067 becomes 10067 then the leading 1 is dropped to get 0067
                String f = String.valueOf(multiplier + Math.mod((dd * multiplier).longValue(), multiplier));
                return w + ',' + f.substring(1);
            } else {
                return w;
            }
        } else {
            return null;
        }
    }
}