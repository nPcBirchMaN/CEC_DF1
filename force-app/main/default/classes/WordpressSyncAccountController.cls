global with sharing class WordpressSyncAccountController 
{
	@AuraEnabled
    public static String AccountSynchronization(String AccountID, String Modo) 
    {
		//recuperamos los datos del socio
		List<Account> listAccount = new List<Account>();
        System.debug('cuenta:'+AccountID);
        listaccount = [SELECT ID,Categor_a__c,Name,FirstName,LastName,PersonEmail,webkul_wws__Woo_Customer_Id__c,N_de_Socio__c FROM Account where Id=:AccountId];
        
        for(Account cuenta :listAccount)
        {
            String rolSocio='';
            boolean callingWS=false;
            
            if(cuenta.Categor_a__c=='Participatiu')
            {
                rolSocio='soci_participatiu';
                callingWS=true;
            }
            else if(cuenta.Categor_a__c=='Ple_dret')
            {
                rolSocio='soci';
                callingWS=true;
            }
            else
            {
                rolSocio='customer';
                callingWS=false;
            }
            if(callingWS)
            {
                if(cuenta.PersonEmail==null || cuenta.PersonEmail=='')
                {
                    callingWS=false;
                }
            }
            if(String.isBlank(cuenta.webkul_wws__Woo_Customer_Id__c))
            {
                Modo='new';
            }
            else
            {
                Modo='update';
            }
            if(String.isBlank(cuenta.PersonEmail))
            {
                callingWS=false;
            }
            if(callingWS)
            {
                CECAccountAPI.UserWordpress uWP = new CECAccountAPI.UserWordpress();
                uWP.username = cuenta.Name;
                uWp.name = cuenta.Name;
                uWP.first_name = cuenta.FirstName;
                uWP.last_name = cuenta.LastName;
                uWP.email=cuenta.PersonEmail;
                List<String> rol = new List<String>();
                rol.add(rolSocio);
                uWP.roles=rol;
                CECAccountAPI.Meta metaData = new CECAccountAPI.Meta();
                metaData.cec_membership_number=String.valueOf(cuenta.N_de_Socio__c);
                uWP.meta=metaData;
                //System.debug('Lanzo JOB');
                //listuWP.add(uWP);
                //mapuWP.put(cuenta.Id, uWP);
                NewAccount_WebserviceQueueble job = new NewAccount_WebserviceQueueble(Modo,uWP,cuenta.Id);
                System.enqueueJob(job);
            }
            
        }
        return('OK');
    }
}