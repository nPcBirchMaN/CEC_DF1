/*
*   @clase : BatchSociNumberToWP
*
*   @Author             :   Nacho Pérez Caro <ignacio.perez@birchmangroup.com>
*   @Created            :   27 MArzo 2019
*   @Description        :   
*		
*/
global class BatchSociNumberToWPBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful
{
 	/*
     * Get all accounts with Soci Number and woocommerceId to send or update the soci number to Wordpress. @TODO Check Scheduled task to see what batch number is needed to send data without deadlocks in woocommerce
     */
    global List <Account> start(Database.BatchableContext bc) {
        List <Account>  cc = [SELECT N_de_Socio__c,Categor_a__c,webkul_wws__Woo_Customer_Id__c  FROM Account WHERE webkul_wws__Woo_Customer_Id__c != '' and N_de_Socio__c >0  ORDER BY N_de_Socio__c DESC NULLS FIRST]; 
        system.debug(' cc ::'+ cc);
        return (cc);
        
    }  
    global void execute(Database.BatchableContext bc, List<Account> listAccount){
        
        system.debug('listAccount::'+ listAccount);
        for(Account acc: listAccount) 
        {
                System.debug('_______________________________________________________');
                List<String> params = new List<String>();
                params.add(acc.webkul_wws__Woo_Customer_Id__c);
            	Decimal aux_numerosocio;
            	aux_numerosocio=acc.N_de_Socio__c;
            	aux_numerosocio=aux_numerosocio.intValue();
                params.add(aux_numerosocio.format()); //formatted in string
            	System.debug('Numero de socio:'+aux_numerosocio.format() + 'Con ID woocommerce: '+acc.webkul_wws__Woo_Customer_Id__c);
                params.add(String.valueOf(acc.N_de_Socio__c));
                String resultAPI = UserSynchro.UserSynchronization('updateSociNumber',params);
        }  
    }
    global void finish(Database.BatchableContext bc)
    {
    }
}