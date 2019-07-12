@isTest
global class ProductSynchroMockImpl implements HttpCalloutMock{
    public String type;

    global ProductSynchroMockImpl(final String type){
             this.type = type;
    }
    
	global HttpResponse respond(HttpRequest req) {
    	HttpResponse res = new HttpResponse();
        CECProductsAPI.ProductsData_Z responseZProdData = new CECProductsAPI.ProductsData_Z();
        responseZProdData.id = 6000;
        if (type == 'Ok') {
            responseZProdData.code = '200';
        	responseZProdData.message = '';
            responseZProdData.data = null;
        } else if (type == 'Error') {
            responseZProdData.code = '400';
        	responseZProdData.message = 'Error al enviar el producto';
            CECProductsAPI.ResponseData responseProd = new CECProductsAPI.ResponseData();
            responseProd.resource_id = '6000';
            responseProd.status = '400';
            responseZProdData.data = responseProd;
        } else if (type == 'SyncError') {
            responseZProdData.code = '404';
        	responseZProdData.message = 'El ID de producto no se encuentra';
            CECProductsAPI.ResponseData responseProd = new CECProductsAPI.ResponseData();
            responseProd.status = '404';
            responseZProdData.data = responseProd;
        }
        
        String responseBody = JSON.serialize(responseZProdData);
       	res.setBody(responseBody);
        return res;    
	}
}