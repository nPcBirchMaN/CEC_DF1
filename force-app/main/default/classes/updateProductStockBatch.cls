global class updateProductStockBatch implements Database.Batchable<Product2>, Database.AllowsCallouts,Database.Stateful{
    
    global List<Product2> productListToUpdate = new List<Product2>();
    global Map<Id, Integer> productAvailabilityMap = new Map<Id, Integer>();
    global List<Product2> start(Database.BatchableContext BC)
    {
        List<OrderItem> oiList = [ SELECT id, product2iD, product2.webkul_wws__woo_Post_id__c, product2.Plazas_disponibles__c , product2.Plazas_totales__c, quantity
                                  FROM OrderItem 
                                  WHERE 	product2.Inicio_inscripci_n__c <= TODAY 
                                  AND product2.Final_inscripci_n__c >= TODAY 
                                  AND product2.webkul_wws__woo_Post_id__c != null
                                  AND order.Etapa__c = '3.Cerrada'
                                  AND product2.Plazas_totales__c != null];
        Integer availableCount;
        
        for(OrderItem oi: oiList) {
            // If product does not exist in map, create it with value Plazas_Totales__c.
            if(!productAvailabilityMap.containsKey(oi.Product2Id)) { productAvailabilityMap.put(oi.Product2Id, Integer.valueOf(oi.product2.Plazas_totales__c));                                                   }
            
            // Retrieve the count, substract quantity and update.
            availableCount = productAvailabilityMap.get(oi.Product2Id);
            availableCount -= Integer.valueOf(oi.quantity);
            productAvailabilityMap.put(oi.Product2Id, availableCount);
        }
        
        // Adjust with rectificative invoice lines.
        List<L_neas_de_factura__c> lfList = [SELECT Cantidad__c, Producto__c FROM L_neas_de_factura__c WHERE Producto__c IN :productAvailabilityMap.keySet() AND Factura__r.Anulaci_n__c = TRUE];
        
        for(L_neas_de_factura__c lf: lfList) {
            availableCount = productAvailabilityMap.get(lf.Producto__c);
            availableCount += Integer.valueOf(lf.Cantidad__c);
            productAvailabilityMap.put(lf.Producto__c, availableCount);
        }
        
        return [SELECT id, webkul_wws__woo_Post_id__c, product2.Plazas_disponibles__c FROM Product2 WHERE Inicio_inscripci_n__c <= TODAY and Final_inscripci_n__c >= TODAY AND webkul_wws__woo_Post_id__c != null AND product2.Plazas_totales__c != null];
    }
    
    global void execute(Database.BatchableContext BC, List<Product2> scope)
    {
        
        // For every product, if exists in availability map, update its Plazas_disponibles__c field.
        for(Product2 p: scope) {
            if(productAvailabilityMap.containsKey(p.id)) {
                p.Plazas_disponibles__c = productAvailabilityMap.get(p.id) < 0 ? 0 : productAvailabilityMap.get(p.id);
                productListToUpdate.add(p);
            }
        }
        
        // If is there any product, update in SF and send data to WooComerce.
        if(!productListToUpdate.isEmpty()) {
            //Database.update(productListToUpdate, false);
            
            // CALL EXTERNAL WS
            if(!Test.isRunningTest()) 
                for(Product2 p: productListToUpdate) { ProductSynchro.ChangeProductStock(String.valueOf(p.webkul_wws__woo_Post_id__c), p.Plazas_disponibles__c, true); }
        }
    } 
    
    global void finish(Database.BatchableContext BC)
    {
        System.debug('productListToUpdate :: ' + productListToUpdate);
        Database.update(productListToUpdate, false);
    }
}