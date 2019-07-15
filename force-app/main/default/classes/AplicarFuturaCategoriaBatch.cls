/*
*   @clase : AplicarFuturaCategoriaBatch
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   27 Sep 2018
*   @Description        :   
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     27 Sep 2018                 Clase
*   15/07/2019 NPC Test GIT
*			
*   
*/
global class AplicarFuturaCategoriaBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global List <Account> start(Database.BatchableContext bc) {
        List <Account>  cc = [SELECT ID, Futura_categor_a_s_cio__c, Categor_a__c, Fecha_aplicaci_n_de_baja__c,Futura_modalidad_del_socio__c, Modalidad__c, Suscriptor_Revista_Monta_a__c,webkul_wws__Woo_Customer_Id__c FROM Account WHERE Fecha_aplicaci_n_de_baja__c = today]; 
        system.debug(' cc ::'+ cc);
        return (cc);
        
    }  
    global void execute(Database.BatchableContext bc, List<Account> coinciden){
        
        system.debug('coinciden::'+ coinciden);
        for(Account acc: coinciden) {
            
            if (acc.Futura_categor_a_s_cio__c != null) {
                acc.Categor_a__c = acc.Futura_categor_a_s_cio__c;
                acc.Futura_categor_a_s_cio__c = null;
            }
            acc.Modalidad__c = acc.Futura_modalidad_del_socio__c;
            acc.Futura_modalidad_del_socio__c = null;
            acc.Fecha_de_alta_de_actividad__c = null;
            acc.Fecha_de_ltima_actualizaci_n__c = date.today();
            acc.Fecha_aplicaci_n_de_baja__c = null;
            
            system.debug('acc.Categor_a__c ::'+ acc.Categor_a__c);
            if(acc.Categor_a__c =='No_soci'){
                acc.Suscriptor_Revista_Monta_a__c = false;
                acc.Modalidad__c = null;
                acc.N_de_Socio__c = null;
                acc.Licencia__c = null;
                acc.Fecha_renovaci_n_suscripci_n__c = null;
                acc.Pagador_Revista_Monta_a__c = false;
                acc.Newsletter__c = false;
               system.debug('acc.Categor_a__c ::'+ acc.Categor_a__c);
            } 
            if(!String.isblank(acc.webkul_wws__Woo_Customer_Id__c))
            {
                string rolSocio='customer';
                if(acc.Categor_a__c=='Participatiu')
                {
                    rolSocio='soci_participatiu';
  
                }
                else if(acc.Categor_a__c=='Ple_dret')
                {
                    rolSocio='soci';
           
                }
                else if(acc.Categor_a__c=='No_soci')
                {
                    rolSocio='customer';
                }
                System.debug('_______________________________________________________');
                List<String> params = new List<String>();
                params.add(acc.webkul_wws__Woo_Customer_Id__c);
                params.add(rolSocio);
                String test = UserSynchro.UserSynchronization('update',params);
            }
            
        } 
        if (coinciden.size() >0) {
            Database.update(coinciden,false);
        }
        
        
    }
    global void finish(Database.BatchableContext bc){
    }
}