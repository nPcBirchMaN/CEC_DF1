public class SendEmail {
	public static String Send(Set<String> emailAdd, String subject, String emailBody)
    {
        System.debug('Lista de emails '+ emailAdd);
        String message = 'Emails enviados correctamente.';
        List<String> emailList = new List<String>();
        /* TODO: descomentar la siguente línea y comentar la 'emailList.add('ignacio.perez@birchmangroup.com');' */
        emailList.addAll(emailAdd); //Rellenamos la lista de los correos a los que enviar el email
        //emailList.add('ignacio.perez@birchmangroup.com');
        //System.debug('SendProductCancelEmail - emailList '+emailList);
        
        //Creamos el email insertándole el listado al que enviar, el asunto y el texto del email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(emailList);
        email.setSubject(subject);
        email.setPlainTextBody(emailBody);
        
        //Enviamos el email
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            if(Test.isRunningTest())
			{
				throw new EmailException('Error al enviar los emails');
			}     
        }catch(exception e){
            System.debug('Error: '+e.getMessage());
            message = 'Error: '+e.getMessage();
        }
        
        return message;
    }
    
    public static String SendHTML(Set<String> emailAdd, String subject, String emailBody)
    {
        System.debug('Lista de emails '+ emailAdd);
        String message = 'Emails enviados correctamente.';
        List<String> emailList = new List<String>();
        /* TODO: descomentar la siguente línea y comentar la 'emailList.add('ignacio.perez@birchmangroup.com');' */
        emailList.addAll(emailAdd); //Rellenamos la lista de los correos a los que enviar el email
        //emailList.add('melanie.caballero@birchmangroup.com');
        //emailList.add('ignacio.perez@birchmangroup.com');
        //System.debug('SendProductCancelEmail - emailList '+emailList);
        
        //Creamos el email insertándole el listado al que enviar, el asunto y el texto del email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(emailList);
        email.setSubject(subject);
        email.setHtmlBody(emailBody);
        
        //Enviamos el email
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            if(Test.isRunningTest())
			{
				throw new EmailException('Error al enviar los emails');
			}     
        }catch(exception e){
            System.debug('Error: '+e.getMessage());
            message = 'Error: '+e.getMessage();
        }
        
        return message;
    }
}