@isTest
global class ProductStockMockImpl implements HttpCalloutMock{
	public String type;

    global ProductStockMockImpl(final String type){
             this.type = type;
    }
    
	global HttpResponse respond(HttpRequest req) {
    	HttpResponse res = new HttpResponse();
        CECProductsAPI.StockResponseData responseStockData = new CECProductsAPI.StockResponseData();
        responseStockData.id = 6000;
        responseStockData.idProduct = '6000';
        responseStockData.status = '200';
        responseStockData.name = 'Product Test';
        
        if (type == 'NoStock') {
            responseStockData.stock_quantity = null;
        } else if (type == 'Suficiente') {
            responseStockData.stock_quantity = 5;
        } else if (type == 'Insuficiente') {
            responseStockData.stock_quantity = 1;
        } else if (type == 'SynchError') {
            responseStockData.code = 'Error';
        }
        
        String responseBody = JSON.serialize(responseStockData);
       	res.setBody(responseBody);
        return res;    
	}
}