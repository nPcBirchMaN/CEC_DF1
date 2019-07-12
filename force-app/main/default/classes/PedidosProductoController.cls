public class PedidosProductoController {
	@AuraEnabled
    public static List<ProductosPedido> getOrdersFromProductId(String ProdId) {
        
        List<ProductosPedido> prodPedList = new List<ProductosPedido>();	//Lista de productos de pedido que queremos mostrar en el lightning component 'lineasPedidosProductos'
        List<Order> orders = new List<Order>();								//Lista de pedidos que contienen el producto que le hemos pasado
        Set<Id> idPedidos = new Set<Id>();									//Lista de ids de los pedidos que tienen el producto
        List<Opportunity> opportunities = new List<Opportunity>();			//Lista de oportunidades que contienen el producto que le hemos pasado
        Set<Id> idOportunidades = new Set<Id>();							//Lista de ids de las oportunidades que tienen el producto

        //Obtenemos los pedidos que tienen como producto de pedido el producto el id del producto que le pasamos
        List<OrderItem> orderIds = [SELECT Id, L_nea_Anulada__c, Order.OrderNumber, OrderId, Quantity, Asistente__c, Asistente__r.Name, UnitPrice 
                                    FROM OrderItem Where UnitPrice >= 0 And Product2Id =: ProdId Order By Order.OrderNumber];
        
        //Recorremos los productos de pedido que contienen el producto, para obtener algunos datos que queremos mostrar
        for (OrderItem prodPedido : orderIds) {
            idPedidos.add(prodPedido.OrderId);
            ProductosPedido prodPed = new ProductosPedido();
            prodPed.orderNumber = prodPedido.Order.OrderNumber;
            prodPed.orderId = prodPedido.OrderId;
            prodPed.quantity = prodPedido.Quantity;
            prodPed.asistente = prodPedido.Asistente__r.Name;
            prodPed.asistenteId = prodPedido.Asistente__c;
            prodPed.unitPrice = prodPedido.UnitPrice.setScale(2);
            prodPed.anulado = prodPedido.L_nea_Anulada__c;
            //guardamos en la lista que utilizaremos para mostrar los datos
            prodPedList.add(prodPed);
        }
        
        if (idPedidos.size() > 0) {
            //Obtenemos los pedidos que tienen el producto en sus líneas de pedido
            orders = [SELECT Id, OrderNumber, Etapa__c, Account.Name, AccountId, Tipo_de_Pago__c FROM Order Where Id =: idPedidos];

            //Recorremos los pedidos para rellenar los datos a mostrar
            for (Order pedido : orders) {
                //Recorremos la lista de productos de pedidos que queremos mostrar, para cuando coincidan los ids, poder completar con los datos del pedido
                for (ProductosPedido prodPedidos : prodPedList) {
                    //Comprobamos que coinciden los ids de los pedidos, para asegurarnos que son el mismo pedido y así completar la información que contiene la lista
                    if (prodPedidos.orderId == pedido.Id) {
                        
                        // prodPedidos.etapa = (pedido.Etapa__c=='2.Negociación')?'2.Anulada':pedido.Etapa__c;
                        if (pedido.Etapa__c=='2.Negociación'){
                            prodPedidos.etapa = '2.Anulada';
                        } else if (pedido.Etapa__c=='0.Inicial'){
                            prodPedidos.etapa = '0.En reserva';
                        } else {
                            prodPedidos.etapa = pedido.Etapa__c;
                        }
                        prodPedidos.accountName = pedido.Account.Name;
                        prodPedidos.accountId = pedido.AccountId;
                        prodPedidos.formaPago = pedido.Tipo_de_Pago__c;
                        prodPedidos.oppOrd = 'Pedido';
                    }
                }
            }
        }
        
        //Obtenemos los pedidos que tienen como producto de pedido el producto el id del producto que le pasamos
        List<OpportunityLineItem> oppIds = [SELECT Id, Opportunity.N_Oportunidad__c, OpportunityId, Quantity, UnitPrice 
                                    FROM OpportunityLineItem Where UnitPrice >= 0 And Product2Id =: ProdId Order By Opportunity.Name];
        
        //Recorremos los productos de pedido que contienen el producto, para obtener algunos datos que queremos mostrar
        for (OpportunityLineItem prodOportunidad : oppIds) {
            idOportunidades.add(prodOportunidad.OpportunityId);
            ProductosPedido prodPed = new ProductosPedido();
            prodPed.orderNumber = prodOportunidad.Opportunity.N_Oportunidad__c;
            prodPed.orderId = prodOportunidad.OpportunityId;
            prodPed.quantity = prodOportunidad.Quantity;
            prodPed.unitPrice = prodOportunidad.UnitPrice.setScale(2);
            //guardamos en la lista que utilizaremos para mostrar los datos
            prodPedList.add(prodPed);
        }
        
        if (idOportunidades.size() > 0) {
            //Obtenemos los pedidos que tienen el producto en sus líneas de pedido
            opportunities = [SELECT Id, Name, StageName, Account.Name, AccountId, Tipo_de_Pago__c FROM Opportunity Where Id =: idOportunidades];

            //Recorremos los pedidos para rellenar los datos a mostrar
            for (Opportunity opp : opportunities) {
                //Recorremos la lista de productos de pedidos que queremos mostrar, para cuando coincidan los ids, poder completar con los datos del pedido
                for (ProductosPedido prodPedidos : prodPedList) {
                    //Comprobamos que coinciden los ids de los pedidos, para asegurarnos que son el mismo pedido y así completar la información que contiene la lista
                    if (prodPedidos.orderId == opp.Id) {
                        prodPedidos.etapa = opp.StageName;
                        prodPedidos.accountName = opp.Account.Name;
                        prodPedidos.accountId = opp.AccountId;
                        prodPedidos.formaPago = opp.Tipo_de_Pago__c;
                        prodPedidos.oppOrd = 'Oportunidad';
                    }
                }
            }
        }
        return prodPedList;
    }
    
    @AuraEnabled
    public static String getTotalVendidos(String ProdId) {
        String totalOpp = '';
        String totalOrd = '';
        //Obtenemos el sumatorio de la cantidad que se ha comprado el producto que recibimos por parámetro
        AggregateResult[] groupedOppResults = [SELECT SUM(Quantity)Total FROM OpportunityLineItem Where Opportunity.StageName = 'Cerrado éxito' And UnitPrice >= 0 And Product2Id =: ProdId];
        for (AggregateResult ar : groupedOppResults) {
            //Guardamos el valor en la variable que utilizaremos para mostrar la suma
            totalOpp = String.valueOf(ar.get('Total'));
            if (totalOpp == null) {
                totalOpp = '0';
            } 
        }
        AggregateResult[] groupedOrdResults = [SELECT SUM(Quantity)Total FROM OrderItem Where Order.Etapa__c = '3.Cerrada' And UnitPrice >= 0 And Product2Id =: ProdId AND L_nea_Anulada__c = False];
        for (AggregateResult ar : groupedOrdResults) {
            //Guardamos el valor en la variable que utilizaremos para mostrar la suma
            totalOrd = String.valueOf(ar.get('Total'));
            if (totalOrd == null) {
                totalOrd = '0';
            }
        }
        String total = String.valueOf(Decimal.valueOf(totalOpp) + Decimal.valueOf(totalOrd));
        total = total.removeEnd('.0');   
        
        return total;
    }
   
    public class ProductosPedido {
        @AuraEnabled
        public String orderNumber {get;set;}
        @AuraEnabled
        public String orderId {get;set;}
        @AuraEnabled
        public Decimal quantity {get;set;}
        @AuraEnabled
        public String asistenteId {get;set;}
        @AuraEnabled
        public String asistente {get;set;}
        @AuraEnabled
        public String etapa {get;set;}
        @AuraEnabled
        public String accountId {get;set;}
        @AuraEnabled
        public String accountName {get;set;}
        @AuraEnabled
        public Decimal unitPrice {get;set;}
        @AuraEnabled
        public String formaPago {get;set;}
        @AuraEnabled
        public String oppOrd {get;set;}
        @AuraEnabled
        public Boolean anulado {get;set;}
    }

}