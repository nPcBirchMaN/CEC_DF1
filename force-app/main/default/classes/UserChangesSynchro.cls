/*
* @ Author: Olaia Aramendia (olaia.aramendia@birchmangroup.com)
* @ Date: 24/08/2018
* Envía a woocommerce la actualización de los datos de las cuentas personales
*/
global with sharing class UserChangesSynchro 
{
    webservice static String UserChangesSynchronization(String modo, Account cuenta) 
    {
		System.debug('Cuenta '+cuenta);
        
        BirchmanGeneralAPI birchmanAPI = new BirchmanGeneralAPI();
        CECAccountAPI.TokenWordpress token = new CECAccountAPI.TokenWordpress();
        CECAccountAPI.Data_Z petitionZResponse = new CECAccountAPI.Data_Z();
        CECAccountAPI.AccountChangesData accountChangesData  = new CECAccountAPI.AccountChangesData();
        List<String> credentialList = new List<String>();
        
        String idAccount = cuenta.webkul_wws__Woo_Customer_Id__c;
        if(modo=='update')
        {
            //Inicio Paso 2: actualización de tipología socio
            String strHttpMethod='POST';
            String strParam = '?consumer_key=' + Label.consumer_key + '&consumer_secret=' + Label.consumer_secret;
            String strEndPoint = Label.strEndPoint + 'customers/'+idAccount;
            List<String> credentialListHeader = new List<String>();
            
            accountChangesData = RellenarAccountChangesDataDesdeCuenta(cuenta);
            String strBody = JSON.serialize(accountChangesData, true);
            System.debug('strBody ' + strBody);
            String responseBody = birchmanAPI.callAPI(strHttpMethod,strBody,strParam,strEndPoint,credentialList);
            System.debug('responseBody ' + responseBody);
            
        }
        
        return 'OK';
    }

	//Pasamos el producto y rellenamos el AccountData que utilizaremos para sincronizar con wooCommerce
    public static CECAccountAPI.AccountChangesData RellenarAccountChangesDataDesdeCuenta (Account cuenta) {
        CECAccountAPI.AccountChangesData accountChangesData  = new CECAccountAPI.AccountChangesData();
        accountChangesData.first_name = cuenta.FirstName;
        accountChangesData.last_name = cuenta.LastName;
        
        CECAccountAPI.BillingData billingData  = new CECAccountAPI.BillingData();
        billingData.first_name = cuenta.FirstName;
		billingData.last_name = cuenta.LastName;
		billingData.address_1 = cuenta.Direcci_n__c;
		//billingData.address_2;
        billingData.city = cuenta.Poblaci_n__c;
        billingData.state = cuenta.Provincia__c; //ISO code or name of the state, province or district
        billingData.postcode = cuenta.C_digo_postal__c;
        System.debug('cuenta.Pais__c '+cuenta.Pais__c);
        billingData.country = cuenta.Pais__c; //ISO code
        billingData.phone = cuenta.Phone;
        
        //Rellenar direccion
        accountChangesData.billing = billingData;
        
        Map<String, String> metaData = new Map<String, String>();
        metaData.put('sf_client_id',cuenta.Id);
        metaData.put('cec_soci_category',cuenta.Categor_a__c);
        metaData.put('cec_soci_modality',cuenta.Modalidad__c);
        metaData.put('birthdate',String.valueOf(cuenta.PersonBirthdate));
        metaData.put('sex',cuenta.Sexo__c);
        metaData.put('id_document_type',cuenta.Tipo_de_documento__c);
        metaData.put('id_document_number',cuenta.N_mero_de_Documento__pc);
        metaData.put('billing_phone_2',cuenta.PersonMobilePhone);
        metaData.put('billing_iban',cuenta.IBAN__c);
        metaData.put('current_account',cuenta.Cuenta_corriente__c);
        metaData.put('privacy_accepted',String.valueOf(cuenta.Tratamiento_de_datos__c));
        metaData.put('cession_images_accepted',String.valueOf(cuenta.Cesi_n_de_imagenes__c));
        
        //Rellenar metaDatos
		accountChangesData.meta_data = CreateMetaDataList(metaData);
        
        
        return accountChangesData;
    }
    
    public static List<Map<String, String>> CreateMetaDataList (Map<String, String> metaData) {
        List<Map<String, String>> metaDataEnviar = new List<Map<String, String>>();
        for (String key : metaData.keySet()) {
            Map<String, String> metaDataString = new Map<String, String>();
            metaDataString.put('value', metaData.get(key));
            metaDataString.put('key', key);
            metaDataEnviar.add(metaDataString);
        }
        return metaDataEnviar;
    }
}