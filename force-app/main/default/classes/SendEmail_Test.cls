/*
*   @clase : SendEmail_Test
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   19/ Sep 2018
*   @Description        :   SendEmail_Test
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     19 Sep 2018                 Clase Test
*			
*/
@istest
public class SendEmail_Test {
    @testSetup 
    public static void setup() {
        TestObjects.initializeObjects();
    }
    @istest
    public static void case1(){
        
        string subject, emailbody;
        Set<String> emailAdd = new Set<String>();
        
        subject = 'CEC - Recordatorio devolución material ';
        emailbody = 'Emails enviados correctamente.';
        emailAdd = (emailAdd);
        SendEmail.Send(emailAdd, subject, emailBody);
        
    }
}