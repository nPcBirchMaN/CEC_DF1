global class RecalculoSociosSchedule implements Schedulable, Database.AllowsCallouts{
    
    global void execute(SchedulableContext SC){
        
        BatchRecalculoSocios RecalSocio = new BatchRecalculoSocios();
        database.executeBatch(RecalSocio,50);
        
        //String Crono = '0 0 0 ? JAN * *';
        //System.schedule('Recalculo de socios ', Crono, RecalSocio);
    }
    
}