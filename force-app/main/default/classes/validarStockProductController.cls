public class validarStockProductController {

    @AuraEnabled
    public static Map<String, Integer> getStockAndSold(Id productId) 
    {
        Map<String, Integer> productData = null;
        Integer total_sales, stock_quantity;
        
        List<Product2> pC = [SELECT Id, Plazas_disponibles__c,Plazas_totales__c,ECommerce__c FROM Product2 where Id=:productId];
        
        for (Product2 prod:pC)
        {
            if(prod.ECommerce__c)
            {
                if(productId != null) {
                    productData = new Map<String, Integer>();
                    total_sales = ProductSynchro.getSoldsByProductId(productId);
                    stock_quantity = ProductSynchro.getStockByProductId(productId);
                    productData.put('stock_quantity', stock_quantity);
                    productData.put('total_sales', total_sales);
                }
                
                System.debug('stock_quantity :: ' + stock_quantity);
                System.debug('total_sales :: ' + total_sales);
            }
            else 
            {
                productData = new Map<String, Integer>();
                //total_sales = ProductSynchro.getSoldsByProductId(productId);
                //stock_quantity = ProductSynchro.getStockByProductId(productId);
                stock_quantity= Integer.valueOf(prod.Plazas_disponibles__c);
                productData.put('stock_quantity', Integer.valueOf(prod.Plazas_disponibles__c));
            }    
        }
        return productData;        
    }
}