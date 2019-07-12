public class CECOrderAPI {
    
    private static Map<String, Id> getAccountsByCustomerId() {
        Map<String, Id> accountMap = new Map<String, Id>();
        for(Account acc: [SELECT id, webkul_wws__Woo_Customer_id__c FROM Account WHERE webkul_wws__Woo_Customer_id__c <> null]) {
            accountMap.put(acc.webkul_wws__Woo_Customer_id__c, acc.Id);
        }
        return accountMap;
    }
    
    private static Map<Id, Account> getAccountsMap() {
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT id, webkul_wws__Woo_Customer_id__c, Categor_a__c FROM Account WHERE webkul_wws__Woo_Customer_id__c <> null]);
        return accountMap;
    }
    
    private static Map<String, Id> getProducts() {
        Map<String, Id> productMap = new Map<String, Id>();
        for(Product2 pro: [Select id, name, webkul_wws__Woo_post_id__c FROM Product2 WHERE webkul_wws__Woo_post_id__c <> null]) {
            productMap.put(String.valueOf(pro.webkul_wws__Woo_post_id__c), pro.id);
        }
        return productMap;
    }
    
    private static Map<Id, Order> getNonCreatedOrderMap() {
        Map<Id, Order> orderMap = new Map<Id, Order>([SELECT id FROM Order WHERE id <> null AND id NOT IN (SELECT Pedido__c FROM Order_Woocomerce__c)]);
        return orderMap;
    }
    
    private static Map<String, Pricebook2> getPricebookMapByName() {
        Map<String, Pricebook2> pricebookMap = new Map<String, Pricebook2>();
        
        for(Pricebook2 pb: [SELECT id, name FROM Pricebook2])
            pricebookMap.put(pb.Name, pb);
        
        return pricebookMap;
    }
    
    private static List<Order_Woocomerce__c> getNonCreatedWoocomerceOrder() {
        return [SELECT id, Name, Pedido__c, Cuenta__c, EffectiveDate__c, Lista_de_precios__c, Status__c, Woocomerce_Order_Id__c FROM Order_Woocomerce__c WHERE Pedido__c = NULL];
    }
    
    private static List<LineItems_Woocomerce__c> getNonCreatedWoocomerceOrderItems() {
        return [SELECT id, Name, Producto_de_pedido__c, Order_Woocomerce__r.Pedido__c, Producto__c, Quantity__c, Order_Woocomerce__r.Pedido__r.Categor_a_del_Cliente__c, Order_Woocomerce__r.Pedido__r.Account.Categor_a__c, PricebookEntry__c FROM LineItems_Woocomerce__c WHERE Producto_de_pedido__c = NULL];
    }
    
    private static Set<String> getOrderExternalIdSet() {
        Set<String> orderSet = new Set<String>();
        for(Order_Woocomerce__c o: [SELECT Woocomerce_Order_Id__c FROM Order_Woocomerce__c WHERE Woocomerce_Order_Id__c <> null])
            orderSet.add(o.Woocomerce_Order_Id__c);
        return orderSet;
    }
    
    // Pricebook2 Name > Product2Id
    private static Map<String, Map<Id, Id>> getPricebookEntryMap() {
        Map<String, Map<Id, Id>> pbeMap = new Map<String, Map<Id, Id>>();
        Map<Id, Id> pbeMapByProductId;
        
        for(PricebookEntry pbe: [SELECT Id, Name,Pricebook2Id,Product2Id,UnitPrice,Pricebook2.Name FROM PricebookEntry]) {
            if(!pbeMap.containsKey(pbe.Pricebook2.Name)) {
                pbeMap.put(pbe.Pricebook2.Name, new Map<Id, Id>());
            }
            
            pbeMapByProductId = pbeMap.get(pbe.Pricebook2.Name);
            pbeMapByProductId.put(pbe.product2Id, pbe.Id);
        }
        
        return pbeMap;
    }
    
    
    
    /*
     *  Stages Woocomerce orders in Order_Woocomerce__c and LineItems_Woocomerce__c objects.
     */
    public static void stageOrdersAndLineItems(Date afterDate, Integer batchSize) {
        
        if(afterDate == null) {
            InvalidParameterValueException e = new InvalidParameterValueException('afterDate', null);
            e.setMessage('afterDate cannot be null.');
            throw e;
        }

        
        if(batchSize == null || batchSize < 0){
            InvalidParameterValueException e = new InvalidParameterValueException('batchSize', null);
            e.setMessage('Batch size cannot be null or lower than zero.');
            throw e;
        }
        
        Integer d = afterDate.day();
		Integer mo = afterDate.month();
		Integer yr = afterDate.year();
        
    	DateTime DT = DateTime.newInstance(yr, mo, d);
        String dateString = DT.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        
        
        Map<String, Order_Woocomerce__c> orderMap = new Map<String, Order_Woocomerce__c>();
        Map<Id, Account> accountMapById = getAccountsMap();
        Set<String> wcOrderExternalIdSet = getOrderExternalIdSet();
        List<LineItems_Woocomerce__c> lineItemsList = new List<LineItems_Woocomerce__c>();
        Map<String, Id> accountMapByCustomerId = getAccountsByCustomerId();
        Map<String, Id> productMap = getProducts();
        Map<String, Pricebook2> pricebookMapByName = getPricebookMapByName();
        Map<String, Map<Id, Id>> pbeMap = getPricebookEntryMap();
        BirchmanGeneralAPI api = new BirchmanGeneralAPI();
		Order_Woocomerce__c order;
        LineItems_Woocomerce__c lineItem;
        Account acc;
        String pricebookTitle;
        
        // Call WS
        String result = api.callAPI('GET', '', '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret + '&after='+dateString+'&per_page='+String.valueOf(batchSize), Label.strEndPoint + 'orders/', new List<String>());
        System.debug(result);
        // Replace conflictive values 
        result = result.replaceAll('number', 'num').replaceAll('currency', 'curr');
        // Deserialize
        List<OrderDTO> orders = (List<OrderDTO>)JSON.deserialize(result, List<OrderDTO>.class);
        
        
        // Create orders from Woocomerce Order List
        for(OrderDTO o: orders) {
            order = new Order_Woocomerce__c();
            if(!String.isBlank(o.customer_id) && accountMapByCustomerId.containsKey(o.customer_id)){
                order.Cuenta__c = accountMapByCustomerId.get(o.customer_id);
            	acc = accountMapById.get(order.Cuenta__c);
            }
            order.Name = o.num;
            order.Woocomerce_Order_Id__c = o.id;
            order.EffectiveDate__c = Date.today();
            order.Status__c = 'Draft';
            
            if(acc.Categor_a__c=='No_soci' || acc.Categor_a__c=='Menor No soci') 
				pricebookTitle = 'No socio';
			else if(acc.Categor_a__c=='Participatiu')
				pricebookTitle = 'Socio participativo';
			else if(acc.Categor_a__c=='Ple_dret' || acc.Categor_a__c=='Menor')
            	pricebookTitle = 'Socios';
            else
            	pricebookTitle = 'Standard Price Book';
            
           	order.Lista_de_precios__c = pricebookMapByName.get(pricebookTitle).id;
            
            orderMap.put(o.id, order);
            
            // Create Line Items
            for(LineItemDTO liDTO: o.line_items) {
                lineItem = new LineItems_Woocomerce__c();
                lineItem.Name = liDTO.name;
                
                // Woocomerce Product Id
                lineItem.Woocomerce_Product_Id__c = liDTO.product_id;
                // Assign product2 if exists.
                if(!String.isBlank(lineItem.Woocomerce_Product_Id__c) && productMap.containsKey(lineItem.Woocomerce_Product_Id__c))
                	lineItem.producto__c = productMap.get(lineItem.Woocomerce_Product_Id__c);
                
                lineItem.Quantity__c = Decimal.valueOf(liDTO.quantity);
                lineItem.subtotal__c = Decimal.valueOf(liDTO.subtotal);
                lineItem.subtotal_tax__c = Decimal.valueOf(liDTO.subtotal_tax);
                lineItem.total__c = Decimal.valueOf(liDTO.total);
                lineItem.Woocomerce_LineItem_Id__c = liDTO.id;
				lineItem.Woocomerce_Order_Id__c = o.id;
                
                if(lineItem.producto__c <> null && pbeMap.containsKey(pricebookTitle) && pbeMap.get(pricebookTitle).containsKey(lineItem.producto__c)) {
                	lineItem.PricebookEntry__c = pbeMap.get(pricebookTitle).get(lineItem.producto__c);
            	}
                lineItemsList.add(lineItem);
            }
        }
        
        // Upsert Orders by Woocomerce_Order_Id__c field.
        Database.UpsertResult[] urOrders = Database.upsert(orderMap.values(), Order_Woocomerce__c.Woocomerce_Order_Id__c, false);
        
        for(LineItems_Woocomerce__c li: lineItemsList) {
            if(!String.isBlank(li.Woocomerce_Order_Id__c) && orderMap.containsKey(li.Woocomerce_Order_Id__c))
                li.Order_Woocomerce__c = orderMap.get(li.Woocomerce_Order_Id__c).id;
        }
        
        // Upsert Order Items by Woocomerce_LineItem_Id__c field.
        Database.UpsertResult[] urLineItems = Database.upsert(lineItemsList, LineItems_Woocomerce__c.Woocomerce_LineItem_Id__c, false);
    }

    public static void syncOrders() {
        List<Order_Woocomerce__c> wooComerceOrderList = getNonCreatedWoocomerceOrder();
		Map<Id, Order> relationOrderWCOrderSF = new Map<Id, Order>();
        Order o;
        
        Boolean validRecord;
        String errorMessageList;
        
        for(Order_Woocomerce__c owc: wooComerceOrderList) {
            validRecord = true;
            errorMessageList = '';
            if(String.isBlank(owc.Cuenta__c)) {
                validRecord = false;
                errorMessageList += '<b>Error:</b> No ha sido asociada una cuenta al registro.' + '<br/>';
            }
            if(owc.EffectiveDate__c == null) {
                validRecord = false;
                errorMessageList += '<b>Error:</b> No tiene effective date.' + '<br/>';
            }
            if(String.isBlank(owc.Lista_de_precios__c)) {
                validRecord = false;
               	errorMessageList += '<b>Error:</b> No tiene una lista de precios asignada.' + '<br/>';                
            }
            if(String.isBlank(owc.Woocomerce_Order_Id__c)) {
                validRecord = false;
                errorMessageList += '<b>Error:</b> No tiene un Woocomerce Order Id asociado.' + '<br/>';
            }
            
            if(validRecord) {
                o = new Order();
				owc.Sync_Status__c = 'Sincronización correcta.';
				o.Name = owc.Name;
				o.EffectiveDate = owc.EffectiveDate__c;
				o.Status = owc.Status__c;
                o.AccountId = owc.Cuenta__c;
                o.PriceBook2Id = owc.Lista_de_precios__c;
                
                relationOrderWCOrderSF.put(owc.id, o);
            } else {
                owc.Sync_Status__c = errorMessageList;
            }
        }
        
        Database.insert(relationOrderWCOrderSF.values(), true);
        
        for(Order_Woocomerce__c owc: wooComerceOrderList) {
            if(relationOrderWCOrderSF.containsKey(owc.id)) {
                o = relationOrderWCOrderSF.get(owc.id);
            	owc.Pedido__c = o.id;
            }
            
        }
        
        Database.update(wooComerceOrderList, true);
        
    }    
    
    
    public static void syncLineItems() {
        List<LineItems_Woocomerce__c> wcList = getNonCreatedWoocomerceOrderItems();
        Map<Id, OrderItem> orderItemRelationMap = new Map<Id, OrderItem>();
        OrderItem oi;
        Boolean validRecord;
        String errorMessageList;
        
        
        for(LineItems_Woocomerce__c wc: wcList) { 
        	validRecord = true;
            errorMessageList = '';
            
            if(String.isBlank(wc.Producto__c)) {
                validRecord = false;
                errorMessageList += '<b>Error:</b> No ha sido asociado un producto al registro.' + '<br/>';
            }
            if(wc.Order_Woocomerce__r == null || wc.Order_Woocomerce__r.Pedido__c == null) {
                validRecord = false;
                errorMessageList += '<b>Error:</b> No tiene pedido asociado.' + '<br/>';
            }
            if(wc.Quantity__c <= 0) {
                validRecord = false;
               	errorMessageList += '<b>Error:</b> No tiene una cantidad estrictamente superior a 0.' + '<br/>';                
            }
            if(String.isBlank(wc.PricebookEntry__c)) {
                validRecord = false;
                errorMessageList += '<b>Error:</b> No tiene un PricebookEntryId asociado.' + '<br/>';
            }
            
            if(validRecord) {
                oi = new OrderItem();
                
				wc.Sync_Status__c = 'Sincronización correcta.';
				oi.OrderId = wc.Order_Woocomerce__r.Pedido__c;
                oi.Product2Id = wc.Producto__c;
                oi.Quantity = wc.Quantity__c;
                oi.PricebookEntryId = Id.valueOf(wc.PricebookEntry__c);
                oi.UnitPrice = 1; // Autocalculated by trigger.
                
                orderItemRelationMap.put(wc.id, oi);
            } else {
                wc.Sync_Status__c = errorMessageList;
            }
        }
        
        Database.insert(orderItemRelationMap.values(), true);
        
        for(LineItems_Woocomerce__c wc: wcList) {
            if(orderItemRelationMap.containsKey(wc.id)) {
                oi = orderItemRelationMap.get(wc.id);
           		wc.Producto_de_pedido__c = oi.id;
            }
            
        }
        
        Database.update(wcList, true);
        
    }
}