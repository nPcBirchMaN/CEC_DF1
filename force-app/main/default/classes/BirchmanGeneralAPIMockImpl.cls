@isTest
global class BirchmanGeneralAPIMockImpl implements HttpCalloutMock{
	global HTTPResponse respond(HttpRequest req) {
    	HttpResponse res = new HttpResponse();
        
        return res;
	}
}