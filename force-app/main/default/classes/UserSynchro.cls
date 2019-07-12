/*
* @ Author: Nacho Pérez (ignacio.perez@birchmangroup.com)
* @ Date: 09/08/2018
* Envía a woocommerce la tipología de socio necesaria
*/
global with sharing class UserSynchro 
{
    webservice static String UserSynchronization(String modo, List<String> parameters) 
    {
		System.debug('Lista de parameters'+parameters);
        /*
        *Paso 1: recuperar token de Authorization Bearer
        *Paso 2: envío de matriz de Rol según socio Salesforce, tipoSocio. Los valores de rol pueden ser: soci, soci_participatiu y customer
        */
        
        BirchmanGeneralAPI birchmanAPI = new BirchmanGeneralAPI();
        CECAccountAPI.TokenWordpress token = new CECAccountAPI.TokenWordpress();
        CECAccountAPI.Data_Z petitionZResponse = new CECAccountAPI.Data_Z();
        string tokenFINAL='';
        //string acoountId = parameters[6];
        //Espacio de peticiones Token:
        //cecProductsAPIZResponse = CECProductsAPI.parse(responseBody);

        //Inicio Paso 1: recuperar token de Authorization Bearer______________________________________________
        string strHttpMethodToken='POST';
        string strBodyToken;
        string strParamToken='';
        string strEndPointToken = Label.strEndPointToken;
        List<String> credentialList = new List<String>();
        token.username=Label.token_usr;
        token.password=Label.token_pwd;
        //cecProductsAPIZ.ProductsData = productData;
        //petitionZ.TokenWordpress = token;
        strBodyToken=JSON.serialize(token, true);
        string responseBodyToken = birchmanAPI.callAPI(strHttpMethodToken,strBodyToken,strParamToken,strEndPointToken,credentialList);
        System.debug('responseBodyToken '+responseBodyToken);
        if(!Test.isRunningTest()) petitionZResponse = CECAccountAPI.parse(responseBodyToken);
        System.debug('Token: '+petitionZResponse.token);
        //Decimal wooPostId = cecProductsAPIZResponse.id;
        tokenFINAL = petitionZResponse.token;
        //Fin Paso 1: recuperar token de Authorization Bearer________________________________________________
        
        if(modo=='update')
        {
            //Inicio Paso 2: actualización de tipología socio
            
            string strHttpMethod='POST';
            string strBody='{\"roles\":[\"'+parameters[1]+'\"]}';
            string strParam=parameters[0];
            string strEndPoint = Label.strEndPointUsr + 'users/';
            System.debug('strEndPoint '+strEndPoint);
            List<String> credentialListHeader = new List<String>();
            credentialListHeader.add(tokenFINAL);
            string responseBody = birchmanAPI.callAPI(strHttpMethod,strBody,strParam,strEndPoint,credentialListHeader);
        }
        if(modo=='updateSociNumber')
        {
            //Actualización del número de socio
            string strHttpMethod='POST';
            //string strBody='{\"roles\":[\"'+parameters[1]+'\"]}';
            string strBody='{\"meta\": {\"cec_membership_number\": [\"'+parameters[1]+'\"]}}';
            string strParam=parameters[0];
            string strEndPoint = Label.strEndPointUsr + 'users/';
            System.debug('strEndPoint '+strEndPoint);
            List<String> credentialListHeader = new List<String>();
            credentialListHeader.add(tokenFINAL);
            string responseBody = birchmanAPI.callAPI(strHttpMethod,strBody,strParam,strEndPoint,credentialListHeader);
        }
        if(modo=='new')
        {
            CECAccountAPI.UserWordpress uWP = new CECAccountAPI.UserWordpress();
            List<String> rolwp = new List<String>();
            CECAccountAPI.Meta metaData = new CECAccountAPI.Meta();
            Boolean notifyUser = Boolean.valueOf(Label.NotifyUserActive);
            
            uWP.name=parameters[0];
            uWP.username=parameters[2]+generateRandomString(5)+parameters[3];
            if(uWP.username.length()>39)
            {
                uWP.username=uWP.username.substring(0, 39);
            }
            uWP.username=uWP.username.replaceAll(' ','_');
            uWP.username=uWP.username.replaceAll('[^a-zA-Z0-9]', '');
            //uWP.username=parameters[4];
            System.debug('username:'+parameters[1]);
            uWP.first_name=parameters[2];
            uWP.last_name=parameters[3];
            uWP.email=parameters[4];
            //uWP.password='cec2018';
            uWP.password='1'+generateRandomString(9);
            rolwp.add(parameters[5]);
            uWP.roles=rolwp;
            
            metaData.cec_membership_number=parameters[7];
            uWP.meta=metaData;
            //objeto serializado
            String strBody=JSON.serialize(uWP, true);
            System.debug('Strbodusalida:'+strBody);
            string strEndPoint = Label.strEndPointUsr + 'users/';
            System.debug('strEndPoint '+strEndPoint);
            string strHttpMethod='POST';
            List<String> credentialListHeader = new List<String>();
            credentialListHeader.add(tokenFINAL);
            
            string responseBody = birchmanAPI.callAPI(strHttpMethod,strBody,'',strEndPoint,credentialListHeader);
            //wait(30000); //se añade espera
            System.debug('ResponseBody:'+responseBody);
            if(!Test.isRunningTest()) petitionZResponse = CECAccountAPI.parse(responseBody);

            //update del account
            //petitionZResponse.id
            string acoountId = parameters[6];
            Account account2Update = new Account();
            account2Update = [SELECT id,webkul_wws__Woo_Customer_Id__c from Account where Id=:acoountId];
            System.debug('Before petitionZResponse' +petitionZResponse);
            if(!Test.isRunningTest()) account2Update.webkul_wws__Woo_Customer_Id__c=petitionZResponse.id.format();
            System.debug('After account2Update' +account2Update);
            database.update (account2Update);
            
            // Send email notification to user
            if(notifyUser)
            	NotifyUser(uWP.email,uWP.password);
            
        }
        
        
        return 'OK';
    }
    public static void NotifyUser(string email, string password)
    {
        PageReference pageRef = Page.NotifyUserTemplateVFP;
        pageRef.setRedirect(true);
		pageRef.getParameters().put('username', email);
    	pageRef.getParameters().put('password',password);    
        
        // getContent cannot be called from a test method. 
        // To avoid this error, initialization of an empty blob is mandatory.
        Blob html = (Test.isRunningTest()) ? Blob.valueOf('') : pageRef.getContent();
        
        
        
        string[] listMails = new List<String>();
        listMails.add(email);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(listMails);
        mail.setSenderDisplayName('Centre Excursionista de Catalunya');
        mail.setSubject('Benvingut/uda al Centre Excursionista de Catalunya!');
        mail.setHtmlBody(html.toString());
        
        try{
            Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.sendEmail(mails);
            if(Test.isRunningTest()) throw new EmailException('Error al enviar los emails'); 
        }catch(exception e){
            System.debug('Error: '+e.getMessage());
        }
    }
    public static String generateRandomString(integer num) 
    {
        
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < num) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr+'!'; 
	}
    
   
}