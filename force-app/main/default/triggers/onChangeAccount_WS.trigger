trigger onChangeAccount_WS on Account (after update,after insert) 
{
    System.debug('onChangeAccount_WS');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        
        System.debug('onChangeAccount_WS');
        //List <CECAccountAPI.UserWordpress> listuWP = new list<CECAccountAPI.UserWordpress>();
        Map <Id,CECAccountAPI.UserWordpress> mapuWP = new Map<id,CECAccountAPI.UserWordpress>();
        
        
        for (Account cuenta: trigger.new)
        {
            System.debug('cuenta '+ cuenta);
            //Solo se hace en el caso de cuentas personales
            if (cuenta.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId()) {
                if(Trigger.isUpdate)
                {
                    Boolean isCuentaModificada = false;
                    Account beforeUpdate = Trigger.oldMap.get(cuenta.id);
                    
                    if(cuenta.Categor_a__c!=beforeUpdate.Categor_a__c)
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
                        else if(cuenta.Categor_a__c=='No_soci')
                        {
                            rolSocio='customer';
                            if(String.isEmpty(cuenta.webkul_wws__Woo_Customer_Id__c))
                                callingWS=false;
                            else
                                callingWS=true;
                        }
                        else if(cuenta.Categor_a__c=='Menor' || cuenta.Categor_a__c=='Menor No soci')
                        {
                            callingWS=false;
                        }
                        else
                        {
                            rolSocio='customer';
                            callingWS=false;
                        }
                        
                        if(callingWS)
                        {
                            System.debug('Cuenta a modificar '+cuenta);
                            if(!(System.isScheduled() || System.isBatch()))
                            {
                                UpdateAccount_WebserviceQueueble job = new UpdateAccount_WebserviceQueueble('update',cuenta.webkul_wws__Woo_Customer_Id__c,rolSocio);
                                System.debug('Limites de queue '+Limits.getQueueableJobs());
                                System.enqueueJob(job);
                            }
                            
                            
                        }
                        
                    }
                    System.debug('cuenta.cambiosSF__c '+cuenta.cambiosSF__c);
                    System.debug('cuenta.Cambios_WooCommerce__c '+cuenta.Cambios_WooCommerce__c);
                    if (cuenta.cambiosSF__c == true) {
                        if (beforeUpdate.FirstName != cuenta.FirstName || beforeUpdate.LastName != cuenta.LastName) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.Direcci_n__c != cuenta.Direcci_n__c || beforeUpdate.Poblaci_n__c != cuenta.Poblaci_n__c || beforeUpdate.C_digo_postal__c != cuenta.C_digo_postal__c) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.Provincia__c != cuenta.Provincia__c || beforeUpdate.Pais__c != cuenta.Pais__c) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.Phone != cuenta.Phone || beforeUpdate.PersonMobilePhone != cuenta.PersonMobilePhone) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.PersonBirthdate != cuenta.PersonBirthdate || beforeUpdate.Sexo__c != cuenta.Sexo__c) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.Tipo_de_documento__c != cuenta.Tipo_de_documento__c || beforeUpdate.N_mero_de_Documento__pc != cuenta.N_mero_de_Documento__pc) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.IBAN__c != cuenta.IBAN__c || beforeUpdate.Cuenta_corriente__c != cuenta.Cuenta_corriente__c) {
                            isCuentaModificada = true;
                        }
                        else if (beforeUpdate.Tratamiento_de_datos__c != cuenta.Tratamiento_de_datos__c || beforeUpdate.Cesi_n_de_imagenes__c != cuenta.Cesi_n_de_imagenes__c) {
                            isCuentaModificada = true;
                        }
                        
                        if(isCuentaModificada == true) {
                            System.debug('Hay que actualizar la cuenta');
                            UpdateAccountChanges_WebserviceQueueble job = new UpdateAccountChanges_WebserviceQueueble('update',cuenta);
                            System.enqueueJob(job);
                        }
                    }
                }
                else if(Trigger.isInsert)
                {
                    System.debug('wordpress nuevo usuario');
                    //aquí procederemos a pasar los parámetros necesarios 
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
                    else if(cuenta.Categor_a__c=='No_soci')
                    {
                        rolSocio='customer';
                        callingWS=false;
                    }
                    else if(cuenta.Categor_a__c=='Menor' || cuenta.Categor_a__c=='Menor No soci')
                    {
                        callingWS=false;
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
                    if(callingWS)
                    {
                        //procedemos a crear aquí mismo un objeto user UserWordpress
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
                        NewAccount_WebserviceQueueble job = new NewAccount_WebserviceQueueble('new',uWP,cuenta.Id);
                        System.enqueueJob(job);
                        //UpdateAccount_WebserviceQueueble job = new UpdateAccount_WebserviceQueueble('update',cuenta.webkul_wws__Woo_Customer_Id__c,rolSocio);
                    }
                    
                    
                }
                
                
                
                
            }
            
        }
        
        //FIN FOR 
    }
}