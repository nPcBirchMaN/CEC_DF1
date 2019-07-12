/*
*   @clase : EmailMaterialSchedule
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   18/ Sep 2018
*   @Description        :   schedule de EmailMaterial
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     18 Sep 2018                 Clase
*			
*   
*/
global class EmailMaterialSchedule implements Schedulable, Database.AllowsCallouts{
    
     /* public static String sched = '0 00 00 * * * ';
    
    global static String scheduleMe() {
        EmailMaterialSchedule SC = new EmailMaterialSchedule(); 
        return System.schedule('My batch Job', sched, SC);
  }
   */   
    global void execute(SchedulableContext SC){
        
        EmailMaterial EmailM = new EmailMaterial();
        database.executeBatch(EmailM,50);                   
    }  
}