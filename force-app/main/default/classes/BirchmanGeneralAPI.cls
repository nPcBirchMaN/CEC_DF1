public class BirchmanGeneralAPI 
{
    //clase para ejecutar las llamadas a la API de Operacional
    
    //metodo para recuperar los credenciales del CEC
    
    
	//metodo para ejecutar la integracion de la API
	
    public String callAPI (String strHttpMehtod, String strBody, String strParam, String strEndPoint, List<String> credentialList)
    {
        //iniciar variables
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setTimeout(15000);
        String currentDate;
        String authorization;
        
      
        HttpResponse response = new HttpResponse();
        String responseBody;
        
        try
        {
            //setear endpoint integracion
            request.setEndpoint(strEndPoint + strParam);

            //setear metodo integracion
            request.setMethod(strHttpMehtod);
            
            //recuperar fecha
            currentDate = system.now().format('dd/MM/yyyy HH:mm:ss');
            
            //recuperar credenciales de los campos encriptados del usuario
            if(credentialList.Size()>0)
            {
                authorization = credentialList.get(0);
                
                //datos cabecera
            	request.setHeader('Authorization', 'Bearer '+authorization);
            }

            
            
            

            request.setHeader('Content-Type', 'application/json');
            
            //datos body, validar que no este vacio
            if(strBody != null && strBody != '')
            {
                request.setBody(strBody);            
            }
            
            //consumir recurso
            System.debug('Request: '+request);
            System.debug('response: '+response);
            response = http.send(request);
            System.debug('response: '+response);
            
            //recuprar respuesta recurso
            responseBody = response.getBody();
            System.debug(responseBody);

        }
        catch(System.Exception e)
        {
            System.debug('ERROR GeneralAPI:' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ' - ' + responseBody);
            responseBody = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ' - ' + responseBody;
        }
                
        //devolver mensaje de respuesta
        return responseBody;
    }
    
    @future(callout=true)
    public static void callAPIFuture (String strHttpMehtod, String strBody, String strParam, String strEndPoint, List<String> credentialList)
    {
        //iniciar variables
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String currentDate;
        String authorization;

        HttpResponse response = new HttpResponse();
        String responseBody;
        
        try
        {
            //setear endpoint integracion
            request.setEndpoint(strEndPoint + strParam);

            //setear metodo integracion
            request.setMethod(strHttpMehtod);
            
            //recuperar fecha
            currentDate = system.now().format('dd/MM/yyyy HH:mm:ss');
            
            //recuperar credenciales de los campos encriptados del usuario
            if(credentialList.Size()>0)
            {
                authorization = credentialList.get(0);
                
                //datos cabecera
                request.setHeader('Authorization', 'Bearer '+authorization);
            }

            
            
            

            request.setHeader('Content-Type', 'application/json');
            
            //datos body, validar que no este vacio
            if(strBody != null && strBody != '')
            {
                request.setBody(strBody);            
            }
            system.debug('strEndPoint + strParam:'+strEndPoint + strParam);
            System.debug('strbody:'+strBody);
            //consumir recurso
            System.debug('Request: '+request);
            System.debug('response: '+response);
            response = http.send(request);
            System.debug('response: '+response);
            
            //recuprar respuesta recurso
            responseBody = response.getBody();

        }
        catch(System.Exception e)
        {
            System.debug('ERROR GeneralAPI:' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ' - ' + responseBody);
            responseBody = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ' - ' + responseBody;
        }
                
        //devolver mensaje de respuesta
        //return responseBody;
    }
    
    
}