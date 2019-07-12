public class SendRemittanceController {
	
    @AuraEnabled
    public static boolean sendToEmail(String email, String remittanceDate) {
        Date dueDate = Date.valueOf(remittanceDate);
        System.debug('due date :: ' + dueDate);
        XMLRemittance xml = new XMLRemittance(dueDate);
        String xmlBlob = xml.generate();
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.contenttype = 'text/xml';
        efa.filename = 'Remittance ' + dueDate + '.xml';
        efa.setBody(Blob.valueOf(xmlBlob));
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        
       	message.subject = 'Centre Excursionista de Catalunya: Remesa XML';
        message.plainTextBody = 'La remesa a data ' + dueDate + ' està adjunta a aquest email.';
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        
        
        return results[0].success;
    }
}