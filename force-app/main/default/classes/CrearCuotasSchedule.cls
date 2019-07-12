global class CrearCuotasSchedule implements Schedulable, Database.AllowsCallouts{
    
    global void execute(SchedulableContext SC){
        
        CrearCuotasBatch CrearCuotas = new CrearCuotasBatch();
        database.executeBatch(CrearCuotas,50);
        
        //String Cron = '0 0 0 ? JAN * *';
        //System.schedule('CrearCuotas ', Cron, CrearCuotas);
    }
    
}