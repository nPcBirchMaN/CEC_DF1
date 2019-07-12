/*
*   @clase : EmailMaterial
*
*   @Author             :   Juan Jose Sáez Martinez <juanjose.saez@birchmangroup.com>
*   @Created            :   14/ Sep 2018
*   @Description        :   Clase que automatiza el envio de email a clientes que tienen material alquilado y les recuerda que tienen que devolverlo
*
*   Modification Log
*   ----------------------------------------------------------------------------------------------------------------------------
*   #       Developer               Date                    Description
*   ----------------------------------------------------------------------------------------------------------------------------    
*   1  Juan Jose Sáez Martinez     14 Sep 2018                 Clase
*			
*   
*/

global class EmailMaterial implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
        global List <Alquiler_Material__c> start(Database.BatchableContext BC) {
            system.debug('BC ::'+ BC);
            List <Alquiler_Material__c>  Em = [SELECT ID, devuelto__c,Email_cliente__c,Material__c,Name, Socio__c, Socio__r.Name,Fecha_Fin__c 
                                               FROM Alquiler_Material__c WHERE devuelto__c= FALSE AND Fecha_Fin__c = TOMORROW ]; 
            
            return Em;
    }
   
    global void execute(Database.BatchableContext BC, List<Alquiler_Material__c> scope){
        
        //string emailAdd= 'Email cliente';
        String subject = 'CEC - Recordatori devolució material';
        Set<string> emailAdd = new Set<string>();   
        for(Alquiler_Material__c acc: scope){     
            emailAdd.add (acc.Email_cliente__c) ;
            Date fechaFin = acc.Fecha_Fin__c;
            Datetime fechaFinDate = (fechaFin != null)? DateTime.newInstance(fechaFin.year(), fechaFin.month(), fechaFin.day()) : null;
            String finString = (fechaFinDate != null)? fechaFinDate.format('dd/MM/yyyy') : '';
            String emailBody = 'Estimat '  + acc.Socio__r.Name+ ',<br><br>Ens posem en contacte amb vostè per recordar-li que el dia <strong>'  + finString +  
                '</strong> haurà de retornar el material <strong>' +acc.Material__c+  '</strong> en les nostres instal·lacions, Carrer del Paradís, nº10  Barcelona.'+
                '<br><br><p>Salutacions cordials,</p><br><img src="http://cec.cat/wp-content/uploads/2018/07/CEC-Logo.png"alt="CEC-Logo" width="12%" />'+
                '<p>Paradís, 10 · 08002 Barcelona<br>Tel. 933 152 311<br><a href="www.cec.cat">www.cec.cat</a></p>';
            
            SendEmail.SendHTML(emailAdd, subject, emailBody);
        }
     
    }
         
       
    
    global void finish(Database.BatchableContext BC){

    }
    
}