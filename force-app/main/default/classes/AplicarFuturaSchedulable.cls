/*
*   @clase : AplicarFuturaSchedulable
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   27  sep 2018
*   @Description        :   schedule de AplicarFuturaSchedulable
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     27 Sep 2018                 Clase
*			
*   
*/
global class AplicarFuturaSchedulable implements Schedulable, Database.AllowsCallouts{
 /*  
      public static String sched = '0 00 00 * * * ';
    
    global static String scheduleMe() {
        AplicarFuturaCategoriaBatchScheldule SC = new AplicarFuturaCategoriaBatchScheldule(); 
        return System.schedule('My batch Job', sched, SC);
  }
 */    
    global void execute(SchedulableContext SC){
        
        AplicarFuturaCategoriaBatch Aplic = new AplicarFuturaCategoriaBatch();
        database.executeBatch(Aplic,10);                   
    }  
}