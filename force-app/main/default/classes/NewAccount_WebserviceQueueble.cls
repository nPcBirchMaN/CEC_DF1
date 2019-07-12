/*
* @ Author: Nacho Pérez (ignacio.perez@birchmangroup.com)
* @ Date: 09/08/2018
* Crea una tarea que permite callouts desde triggers al ejecutarse en batch
*/
public class NewAccount_WebserviceQueueble implements Queueable, Database.AllowsCallouts
{
    public final String modo;
    public final CECAccountAPI.UserWordpress userWP;
    public final String idAccount;
    public final Map<Id,CECAccountAPI.UserWordpress> mapUsers;
    public NewAccount_WebserviceQueueble(String modoInput, CECAccountAPI.UserWordpress userWPInput,String IdInput)
    {
        modo=modoInput;
        userWP = userWPInput;
        idAccount=IdInput;
        //modo=modoInput;
        //this.mapUsers = mapuWP;
    }

	public void execute(QueueableContext context)
    {
        //aquí ya si eso lanzamos los webservices pero recorriendo el map


        List<String> params = new List<String>();
        if(modo=='update')
        {
            Account account2Update = [SELECT id,webkul_wws__Woo_Customer_Id__c from Account where Id=:idAccount];
            params.add(account2Update.webkul_wws__Woo_Customer_Id__c);//0
            params.add(userWP.roles[0]);//1
            /*params.add(userWP.name);
            params.add(userWP.username);
            params.add(userWP.first_name);
            params.add(userWP.last_name);
            params.add(userWP.email);
            params.add(userWP.roles[0]);
            params.add(idAccount);//6
            params.add(userWP.Meta.cec_membership_number);//7
            System.debug('Lanzo userSync');*/
        }
        else 
        {
            params.add(userWP.name);
            params.add(userWP.username);
            params.add(userWP.first_name);
            params.add(userWP.last_name);
            params.add(userWP.email);
            params.add(userWP.roles[0]);
            params.add(idAccount);//6
            params.add(userWP.Meta.cec_membership_number);//7
            System.debug('Lanzo userSync');
        }
            
        
        String test = UserSynchro.UserSynchronization(modo,params);
		
        
    }
}