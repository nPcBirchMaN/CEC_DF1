global class SociNumberSchedulable implements Schedulable, Database.AllowsCallouts{

    global void execute(SchedulableContext SC){
        
        BatchSociNumberToWPBatch Aplic = new BatchSociNumberToWPBatch();
        database.executeBatch(Aplic,10);                   
    }  
}