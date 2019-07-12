public class CECProductsResponseMessge {

 public class ResponseMessage 
{
     public string idProduct;
     public Integer stock_quantity = 1;
     
     
     
    // productData.stock_quantity = prod.stock_quantity;
     String StockQuantity = String.valueOf(stock_quantity);
     //prod.stock_quantity.round(System.RoundingMode.CEILING)
 		
 }   
    
 
    
      public static ResponseMessage parse(String json) 
    {
        return (ResponseMessage) System.JSON.deserialize(json, ResponseMessage.class);
    }
    
}