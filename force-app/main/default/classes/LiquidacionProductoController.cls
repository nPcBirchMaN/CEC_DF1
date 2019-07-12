public class LiquidacionProductoController {
	@AuraEnabled
    public static List<ProductoFacturas> getFacturasFromProductId(String ProdId) {
        
        List<ProductoFacturas> prodFactList = new List<ProductoFacturas>();	//Lista de productos de pedido que queremos mostrar en el lightning component 'lineasPedidosProductos'
        List<Factura__c> facturas = new List<Factura__c>();								//Lista de pedidos que contienen el producto que le hemos pasado
        Set<Id> idFacturas = new Set<Id>();									//Lista de ids de los pedidos que tienen el producto
        Set<Id> numFactura = new Set<Id>();
        //Obtenemos los pedidos que tienen como producto de pedido el producto el id del producto que le pasamos
            List<L_neas_de_factura__c> linFacturasIds = [SELECT Id, Factura__c, Cantidad__c, Importe__c FROM L_neas_de_factura__c Where Producto__c =:ProdId Order By Factura__r.N_mero_de_factura__c];
        
        //Recorremos los productos de pedido que contienen el producto, para obtener algunos datos que queremos mostrar
        for (L_neas_de_factura__c linFacturas : linFacturasIds) {
            ProductoFacturas prodFact = new ProductoFacturas();
            prodFact.quantity = linFacturas.Cantidad__c;
            prodFact.unitPrice = linFacturas.Importe__c.setScale(2);
            prodFact.billingId = linFacturas.Factura__c;
            //guardamos en la lista que utilizaremos para mostrar los datos.
            //Registramos la factura para que no duplique.
            if(!idFacturas.contains(linFacturas.Factura__c)) {
                idFacturas.add(linFacturas.Factura__c);
            	prodFactList.add(prodFact); 
            }
            else
            {
                prodFactList.add(prodFact); 
            }
            
        }
        
        if (idFacturas.size() > 0) {
            //Obtenemos los pedidos que tienen el producto en sus líneas de pedido
            facturas = [SELECT Id, N_mero_de_factura__c, Referencia__c, Cliente__r.Name, Cliente__c, Tipo_de_pago__c, Tipo_de_Factura__c, Estado__c, Id_de_Pedido__c, Id_de_Oportunidad__c
                        FROM Factura__c Where Id =: idFacturas];

            //Recorremos los pedidos para rellenar los datos a mostrar
            for (Factura__c factura : facturas) {
                //Recorremos la lista de productos de pedidos que queremos mostrar, para cuando coincidan los ids, poder completar con los datos del pedido
                for (ProductoFacturas prodFacturas : prodFactList) {
                    //Comprobamos que coinciden los ids de los pedidos, para asegurarnos que son el mismo pedido y así completar la información que contiene la lista
                    if (prodFacturas.billingId == factura.Id) {
                        prodFacturas.estado = factura.Estado__c;
                        prodFacturas.accountName = factura.Cliente__r.Name;
                        prodFacturas.accountId = factura.Cliente__c;
                        prodFacturas.numFactura = factura.N_mero_de_factura__c;
                        prodFacturas.tipoPago = factura.Tipo_de_pago__c;
                        prodFacturas.numReferencia = factura.Referencia__c;
                        prodFacturas.tipoFactura = factura.Tipo_de_Factura__c;
                        prodFacturas.tipoPedido = (factura.Id_de_Pedido__c != null)? 'Pedido':'Oportunidad';
                    }
                }
            }
        }
        return prodFactList;
    }
    
    @AuraEnabled
    public static List<ProductoTotales> getTotalFacturado(String ProdId) {
        List<ProductoTotales> prodTotalList = new List<ProductoTotales>();	//Lista de productos de pedido que queremos mostrar en el lightning component 'lineasPedidosProductos'
        //Obtenemos el sumatorio de la cantidad que se ha comprado el producto que recibimos por parámetro
        AggregateResult[] groupedResults = [SELECT SUM(Importe__c)totalFacturas FROM L_neas_de_factura__c Where Producto__c =: ProdId];
        Product2 productCoste = [SELECT Id, Coste_total__c From Product2 Where Id =:ProdId LIMIT 1];
        
        for (AggregateResult ar : groupedResults) {
            //Guardamos el valor en la variable que utilizaremos para mostrar la suma
            ProductoTotales prodTotal = new ProductoTotales();
            prodTotal.totalFacturas = String.valueOf(ar.get('totalFacturas'));
            prodTotal.Id = ProdId;
            prodTotalList.add(prodTotal);
        }
            
        for (ProductoTotales prodTot : prodTotalList) {
            if (prodTot.Id == productCoste.Id){
                String gananciaTotal = null;
                String totalFacturas = prodTot.totalFacturas;
                String costeTotal = String.valueOf(productCoste.Coste_total__c);
                
                if (totalFacturas != null && costeTotal != null) {
                    Decimal totalFact = Decimal.valueOf(totalFacturas);
                    Decimal totalCost = Decimal.valueOf(costeTotal);
                    Decimal ganancia = totalFact - totalCost;
                    gananciaTotal = String.valueOf(ganancia);
                } else if (totalFacturas != null && costeTotal == null){
                    gananciaTotal = totalFacturas;
                } else if (totalFacturas == null && costeTotal != null){
                    gananciaTotal = String.valueOf(0 - productCoste.Coste_total__c);
                } 
                
                if (totalFacturas != null) {
                    totalFacturas = totalFacturas.removeEnd('.0');
                    prodTot.totalFacturas = totalFacturas + '€';
                } else {
                    prodTot.totalFacturas = '0€';
                }
                if (costeTotal != null) {
                    costeTotal = costeTotal.removeEnd('.00');
                    prodTot.costeTotal = costeTotal + '€';
                } else {
                    prodTot.costeTotal = '0€';
                }
                
                if (gananciaTotal != null) {
                    gananciaTotal = gananciaTotal.removeEnd('.00');
                    gananciaTotal = gananciaTotal.removeEnd('.0');
                    prodTot.gananciaTotal = gananciaTotal + '€';
                } else {
                    prodTot.gananciaTotal = '0€';
                }
            }
        }
        return prodTotalList;
    }
    
    public class ProductoFacturas {
        @AuraEnabled
        public String numFactura {get;set;}
        @AuraEnabled
        public String billingId {get;set;}
        @AuraEnabled
        public String tipoFactura {get;set;}
        @AuraEnabled
        public String tipoPago {get;set;}
        @AuraEnabled
        public String numReferencia {get;set;}
        @AuraEnabled
        public String estado {get;set;}
        @AuraEnabled
        public String accountId {get;set;}
        @AuraEnabled
        public String accountName {get;set;}
        @AuraEnabled
        public Decimal quantity {get;set;}
        @AuraEnabled
        public Decimal unitPrice {get;set;}
        @AuraEnabled
        public String tipoPedido {get;set;}
    }
    
    public class ProductoTotales {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String totalFacturas {get;set;}
        @AuraEnabled
        public String costeTotal {get;set;}
        @AuraEnabled
        public String gananciaTotal {get;set;}
    }

}