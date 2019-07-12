// Based in https://docs.oracle.com/cd/E16582_01/doc.91/e15104/fields_sepa_pay_file_appx.htm#EOAEL01692
public class XMLRemittance {    
    
    private final string partyName = 'CENTRE EXCURSIONISTA DE CATALUNYA';
    private final string partyIBAN = 'ES3021000900990201931734';
    private final string partyId = 'ES89000G08944209';
    private final string msgId;
    private final string pmtInfId;
    private final decimal numberOfTransactions;
    private final decimal controlSum;
    private List<Vencimiento__c> vencimientoList;
    
    private final string paymentMethod = 'DD';
    
    
    private String formatDate(Datetime t) {
        return (String.valueOf(Datetime.now()).replace(' ', 'T'));
    }
    
    private String generateRandomString(Integer len) {
        return String.valueOf(Math.Round(Math.Random() * ((Math.pow(10,len) - 1)-Math.pow(10,len -1)) + Math.pow(10,len -1)));
    }
    
    private XMLStreamWriter s;
    
    public XMLRemittance(Date endDate) {
        numberOfTransactions = [SELECT COUNT() FROM Vencimiento__c WHERE Remesada__c = False AND Fin_de_Facturaci_n__c <= :endDate AND IBAN__c != null];
        AggregateResult[] ar = [SELECT SUM(Importe_Total__c) FROM Vencimiento__c WHERE Remesada__c = False AND Fin_de_Facturaci_n__c <= :endDate AND IBAN__c != null];
        System.debug('ar ' + ar);
        controlSum = ((Decimal)ar[0].get('expr0')).setScale(2);
		vencimientoList = [SELECT id, name, Importe_Total__c, Factura__r.Cliente__r.Name, Factura__r.Cliente__r.N_mero_de_Documento__pc, IBAN__c, Fecha_firma_mandato__c FROM Vencimiento__c WHERE Remesada__c = False AND Fin_de_Facturaci_n__c <= :endDate AND IBAN__c != null];  

        s = new XMLStreamWriter();
        msgId = generateRandomString(5);
        pmtInfId = msgId + '-' + Datetime.now().format('dd/MM/yyyy');
    }
    
    private void setGroupHeaders() {
        s.writeStartElement(null, 'CstmrDrctDbtInitn', null);
        	s.writeStartElement(null, 'MsgId', null);
        		s.writeCharacters(msgId);
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'CreDtTm', null);
        		s.writeCharacters(formatDate(Datetime.now()));
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'NbOfTxs', null);
        		s.writeCharacters(String.valueOf(numberOfTransactions));
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'CtrlSum', null);
        		s.writeCharacters(String.valueOf(controlSum));
        	s.writeEndElement();
        	
        	s.writeStartElement(null, 'InitgPty', null);
        		s.writeStartElement(null, 'Nm', null);
        			s.writeCharacters(partyName);
        		s.writeEndElement();
        
        		s.writeStartElement(null, 'Id', null);
        			s.writeStartElement(null, 'PrvtId', null);
        				s.writeStartElement(null, 'Othr', null);
        					s.writeStartElement(null, 'Id', null);
        						s.writeCharacters(partyId);
        					s.writeEndElement(); 
        				s.writeEndElement();   
        			s.writeEndElement();        
        		s.writeEndElement();
        	s.writeEndElement();
        
        s.writeEndElement();
    }
    
    // Possible updates:
    // If all required fields are not filled, don't include customer in the remittance.
    private void setPaymentInformationElements() {
        s.writeStartElement(null, 'PmtInf', null);
        	s.writeStartElement(null, 'PmtInfId', null);
        		s.writeCharacters(pmtInfId);
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'PmtMtd', null);
        		s.writeCharacters(paymentMethod);
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'NbOfTxs', null);
        		s.writeCharacters(String.valueOf(numberOfTransactions));
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'CtrlSum', null);
        		s.writeCharacters(String.valueOf(controlSum));
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'PmtTpInf', null);
        		s.writeStartElement(null, 'SvcLvl', null);
        			s.writeStartElement(null, 'Cd', null);
        				s.writeCharacters('SEPA'); // EDIT X
        			s.writeEndElement();
        		s.writeEndElement();
        
        		s.writeStartElement(null, 'LclInstrm', null);
        			s.writeStartElement(null, 'Cd', null);
        				s.writeCharacters('CORE'); // EDIT X
        			s.writeEndElement();
        		s.writeEndElement();
        
        		s.writeStartElement(null, 'SeqTp', null);
        			s.writeCharacters('RCUR'); // EDIT X
        		s.writeEndElement();
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'ReqdColltnDt', null);
        		s.writeCharacters(String.valueOf(Date.today())); // EDIT X
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'Cdtr', null);
        		s.writeStartElement(null, 'Nm', null);
        			s.writeCharacters(partyName); // EDIT X
        		s.writeEndElement();
        	s.writeEndElement();
        	
        	s.writeStartElement(null, 'CdtrAcct', null);
        		s.writeStartElement(null, 'Id', null);
        			s.writeStartElement(null, 'IBAN', null);
        				s.writeCharacters(partyIBAN); // EDIT X
        			s.writeEndElement();
        		s.writeEndElement();
        	s.writeEndElement();
        
        	s.writeStartElement(null, 'CdtrAgt', null);
        		s.writeStartElement(null, 'FinInstnId', null); // ? with single close
        		s.writeEndElement();
        	s.writeEndElement();
        	
        	s.writeStartElement(null, 'CdtrSchmeId', null);
        		s.writeStartElement(null, 'Id', null);
        			s.writeStartElement(null, 'PrvtId', null);
        				s.writeStartElement(null, 'Othr', null);
        					s.writeStartElement(null, 'Id', null);
        						s.writeCharacters(partyId); // EDIT X
        					s.writeEndElement();
        
        					s.writeStartElement(null, 'SchmeNm', null);
        						s.writeStartElement(null, 'Prtry', null);
        							s.writeCharacters('SEPA'); // EDIT X
        						s.writeEndElement();
        					s.writeEndElement();
        				s.writeEndElement();
        			s.writeEndElement();
        		s.writeEndElement();
        	s.writeEndElement();
        	
        	// Generate transaction list
        	setListTransactions();
        s.writeEndElement();
    }
    
    private void setListTransactions() {
        integer i = 1;
        for(Vencimiento__c v: vencimientoList) {
            s.writeStartElement(null, 'DrctDbtTxInf', null);
        		s.writeStartElement(null, 'PmtId', null);
        			s.writeStartElement(null, 'EndToEndId', null);
        				s.writeCharacters('SO/'+msgId+'/'+i); // Edit ??
        			s.writeEndElement();
        		s.writeEndElement();
            	
            	s.writeStartElement(null, 'InstdAmt', null);
            		s.writeAttribute(null, null, 'Ccy', 'EUR');
            		if(!String.isBlank(String.valueOf(v.Importe_Total__c)))
        				s.writeCharacters(String.valueOf(v.Importe_Total__c)); // EDIT X
        		s.writeEndElement();
            	
            	s.writeStartElement(null, 'DrctDbtTx', null);
        			s.writeStartElement(null, 'MndtRltdInf', null);
        				s.writeStartElement(null, 'MndtId', null);
            				if(!String.isBlank(String.valueOf(v.Factura__r.Cliente__r.N_mero_de_Documento__pc)))
        						s.writeCharacters(String.valueOf(v.Factura__r.Cliente__r.N_mero_de_Documento__pc)); // Edit
        				s.writeEndElement();
            			s.writeStartElement(null, 'DtOfSgntr', null);
            				if(!String.isBlank(String.valueOf(v.Fecha_firma_mandato__c)))
        						s.writeCharacters(String.valueOf(v.Fecha_firma_mandato__c)); // Edit X
        				s.writeEndElement();
        			s.writeEndElement();
            		
            		s.writeStartElement(null, 'CdtrSchmeId', null);
        				s.writeStartElement(null, 'Id', null);
        					s.writeStartElement(null, 'PrvtId', null);
        						s.writeStartElement(null, 'Othr', null);
        							s.writeStartElement(null, 'Id', null);
        								s.writeCharacters(partyId); // Edit
        							s.writeEndElement();
            						s.writeStartElement(null, 'SchmeNm', null);
        								s.writeStartElement(null, 'Prtry', null);
        									s.writeCharacters('SEPA');
        								s.writeEndElement();
        							s.writeEndElement();
        						s.writeEndElement();
        					s.writeEndElement();
        				s.writeEndElement();
        			s.writeEndElement();
            		
        		s.writeEndElement();
            
            	s.writeStartElement(null, 'DbtrAgt', null);
            		s.writeStartElement(null, 'FinInstnId', null);
        			s.writeEndElement();
        		s.writeEndElement();
            
            	s.writeStartElement(null, 'Dbtr', null);
            		s.writeStartElement(null, 'Nm', null);
            			if(!String.isBlank(v.Factura__r.Cliente__r.Name))
            				s.writeCharacters(v.Factura__r.Cliente__r.Name);
        			s.writeEndElement();
        		s.writeEndElement();
            
            	s.writeStartElement(null, 'DbtrAcct', null);
            		s.writeStartElement(null, 'Id', null);
            			s.writeStartElement(null, 'IBAN', null);
            				if(!String.isBlank(v.IBAN__c))
            					s.writeCharacters(v.IBAN__c);
        				s.writeEndElement();
        			s.writeEndElement();
        		s.writeEndElement();
            	
            	s.writeStartElement(null, 'Purp', null);
            		s.writeStartElement(null, 'Cd', null);
            			s.writeCharacters('RCPT');
        			s.writeEndElement();
        		s.writeEndElement();
            
            	s.writeStartElement(null, 'RmtInf', null);
            		s.writeStartElement(null, 'Ustrd', null);
            			s.writeCharacters('Quota soci CEC');
        			s.writeEndElement();
        		s.writeEndElement();
            
            
        	s.writeEndElement();
            i++;
        }
    }
    
    public String generate() {
        // Document body
        s.writeStartDocument('UTF-8', '1.0');
        s.writeStartElement(null, 'Document', null);
        	s.writeAttribute('xmlns', '', 'xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        	s.writedefaultNamespace('urn:iso:std:iso:20022:tech:xsd:pain.008.001.02');
        	s.writeStartElement(null, 'CstmrDrctDbtInitn', null);
                // Set Remittance information
                setGroupHeaders();
                setPaymentInformationElements();
        	s.writeEndElement();
        s.writeEndElement();
        s.writeEndDocument();
        
        return s.getXmlString();
    }
}