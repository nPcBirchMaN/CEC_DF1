global class MenorsBatch implements Database.Batchable<sObject>
{
	private String query = 'Select id, name, modalidad__c, categor_a__c, PersonBirthDate from Account WHERE Categor_a__c = \'Menor\' AND Modalidad__c = \'Juniors 14-17\' AND PersonBirthDate <= TODAY';
    
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        for(Account menor: scope) {
            menor.PersonEmail = null;
            menor.Futura_categor_a_s_cio__c = 'Ple_dret';
            menor.Futura_modalidad_del_socio__c = 'Jóvenes 18-25';
        }
        
        Database.update(scope);
    } 
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}