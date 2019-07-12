public class CancelOrderItemMailController {
    public String[] productList {get; set;}
    
    public CancelOrderItemMailController() {
        if(ApexPages.currentPage().getParameters().containsKey('products'))
        	this.productList = ApexPages.currentPage().getParameters().get('products').split(';');
    }
}