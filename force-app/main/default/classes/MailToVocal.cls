global with sharing class MailToVocal 
{
    @AuraEnabled
    webservice static String MailVocal(String ProdId) 
    {
        //este método se invoca desde el Lighning Component mailToVocal
        //yihaaaa
        String returnMessage;
        Integer contadorInscritos = 0;
        List<String> inscritos = new List<String>();
        string[] listMails = new List<String>();
        Product2 producto = [SELECT id, Name, Vocal__r.Email__c, Profesional__r.Email__c FROM Product2 WHERE ID=:ProdId];
        String nombreProducto=producto.Name;
        
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        
        listMails.add(userEmail);
        
        if(producto.Vocal__r.Email__c !=null)
        {
            listMails.add(producto.Vocal__r.Email__c);
        }
        if(producto.Profesional__r.Email__c!=null)
        {
            listMails.add(producto.Profesional__r.Email__c);
        }
        if(listMails.size()>0)
        {
            //realizamos el envío de los inscritos a estos producto, para ello debemos buscar todos pedidos que contengan este producto  
            AggregateResult[] items;
            items = [select OrderId from OrderItem where Product2Id=:ProdId group by OrderId];
            //items = [select OrderId from OrderItem where Product2Id=:ProdId];
            List<Id> orderId = new List<Id>();
            for(AggregateResult aux0 :items)
            {
                orderId.add((Id)aux0.get('OrderId'));
            }
            List<Order> order = new List<Order>();
            order = [select Datos_cuenta__c from Order where id=:orderId];
            inscritos.add('La llista dels inscrits \r\n');
            for (Order aux1 :order)
            {
                System.debug('Test:'+aux1.Datos_cuenta__c);
                inscritos.add(aux1.Datos_cuenta__c);
                contadorInscritos ++;
                
            }
            
            returnMessage='Email enviado';
            sendEmail(listMails,inscritos,nombreProducto, contadorInscritos, ProdId);
        }
        else
        {
            returnMessage='El campo vocal y/o profesional no está informado';
        }
        return returnMessage;
    }
    
    public static void sendEmail(List<String> listMails,List<String> body,String nombreProducto, Integer contadorInscritos, String ProdId)
    { 
        /*
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setToAddresses(listMails);
mail.setSenderDisplayName('Centre Excursionista de Catalunya');
mail.setSubject('Notificació dels inscrits a '+nombreProducto);

String bodyMail = 'Notificació dels inscrits a ' + nombreProducto +'\r\n';
for(String cuerpo:body)
{
bodyMail = bodyMail + cuerpo+'\r\n';    
}
bodyMail = bodyMail + 'El total dels inscrits és de : ' + contadorInscritos +'\r\n';  
mail.setPlainTextBody(bodyMail);

Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage> {mail};
Messaging.sendEmail(mails);
*/
        
        PageReference vfPageRef= Page.EnvioInscritosPDF;
        vfPageRef.getParameters().put('id', ProdId);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //message.toAddresses = new String[] { 'daniel.palacios@birchmangroup.com', 'ignacio.perez@birchmangroup.com'};
        //message.toAddresses = new String[] { 'melanie.caballero@birchmangroup.com'};
        message.setToAddresses(listMails);
        message.optOutPolicy = 'FILTER';
        message.subject = 'Notificació dels inscrits a ' + nombreProducto;
        /*
message.plainTextBody = 'Benvolgut/da,\r\n' + 
'Com a voluntari del Centre Excursionista de Catalunya i coordinador d’una activitat en els pròxims dies, et fem arribar el document adjunt amb els detalls ' +
'de la mateixa i la llista d’inscrits.\r\n' + 
'T’agrairem que un cop finalitzada aquesta activitat ens retornis aquest document, amb les signatures dels inscrits que hi participin, per al seu registre i arxiu.\r\n' +
'Salutacions cordials,';
*/
        String mailTxt = '<div style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima,Arial,sans-serif; font-size: 11px;"><p>Benvolgut/da,</p>' + 
            '<p>Com a voluntari del Centre Excursionista de Catalunya i coordinador d’una activitat en els pròxims dies, et fem arribar el document adjunt amb els detalls ' +
            'de la mateixa i la llista d’inscrits.</p>' + 
            '<p>T’agrairem que un cop finalitzada aquesta activitat ens retornis aquest document, amb les signatures dels inscrits que hi participin, per al seu registre i arxiu.</p>' +
            '<p>Salutacions cordials,</p><br/>' +
            '<img src="http://cec.cat/wp-content/uploads/2018/07/CEC-Logo.png"alt="CEC-Logo" width="18%" />' +
            '<p>Paradís, 10 · 08002 Barcelona<br>Tel. 933 152 311<br><a href="www.cec.cat">www.cec.cat</a></p></div><br/>' +
            '<div style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima,Arial,sans-serif; font-size: 9px;"><p>Aquest missatge s’adreça exclusivament a qui va destinat i pot contenir ' +
            'informació privilegiada o confidencial i dades de caràcter personal, la difusió de les quals és regulada per la Llei orgànica de protecció de dades i la Llei de serveis de ' +
            'la societat de la informació. Si no sou la persona destinatària indicada (o la responsable de lliurar-lo a qui va destinat), no heu de copiar aquest missatge ni lliurar-lo a ' +
            'tercers per cap concepte. Si heu rebut aquest missatge per error o l’heu aconseguit per altres mitjans, us demanem que ens ho comuniqueu immediatament per aquesta mateixa ' +
            'via i l’elimineu irreversiblement.</p>' +
            '<p>Abans d’imprimir aquest missatge electrònic penseu en el medi ambient.</p></div>';
        
        message.setHtmlBody(mailTxt);
        
        Messaging.EmailFileAttachment pdfAttachment = new Messaging.EmailFileAttachment();
        pdfAttachment.setFileName('Llista inscrits.pdf');
        
        if(!Test.isRunningTest()) pdfAttachment.setBody(vfPageRef.getContent());
        else pdfAttachment.setBody(blob.valueOf('Mensaje de prueba.'));
        
        pdfAttachment.setContentType('application/pdf');
        
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {pdfAttachment});
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
    }
    
    
}