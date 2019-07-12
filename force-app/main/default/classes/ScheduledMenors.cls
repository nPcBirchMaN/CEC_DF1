global class ScheduledMenors implements Schedulable {
	global void execute(SchedulableContext sc) {
    	MenorsBatch b = new MenorsBatch(); 
      	database.executeBatch(b);
   	}
}