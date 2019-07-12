public class QRPageController {
    public Id recordId {get; set;}
	public string data {get; set;}
	public string sObjectType {get; set;}  
    public string baseUrl {get; set;}
    public String imgEncoded;
    public QRPageController() {
        baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm();
        // Data to be stored into QR.
        data = ApexPages.currentPage().getParameters().get('data');
        // sObject type to referenciate in the url.
        sObjectType = ApexPages.currentPage().getParameters().get('sObject');
		// Record Id Saving
        if(ApexPages.currentPage().getParameters().containsKey('recordId') && ApexPages.currentPage().getParameters().containsKey('qrEncoded')) {
            recordId = Id.valueOf(ApexPages.currentPage().getParameters().get('recordId'));
            imgEncoded = ApexPages.currentPage().getParameters().get('qrEncoded');
        }        	
    }
    
    public void getExecute() {
        if(!String.isEmpty(recordId) && !String.isEmpty(imgEncoded) && recordId != null && imgEncoded != null)
        	execute(recordId, imgEncoded);
    }
    
    @testVisible
    private static blob getImageAsBlob(String data) {
        // Substract b64 data
        data = data.substringAfter(',');
        // Decode as blob
        blob img = EncodingUtil.base64Decode(data);
        // Return image as blob
        return img;
    }
    
    @testVisible
    private static boolean saveImageToRecordAsAttachment(Id recordId, Blob data) {
        boolean returnValue = False;
       	Savepoint sp;
        Attachment n;
        Integer qrCodesCount;
        
        qrCodesCount = [SELECT count() FROM attachment WHERE name = :'qrCode.png' AND parentId = :recordId];
        
        // if QR does not exist for a partircular recordId, create it.
        if(qrCodesCount == 0 && data <> null) {
            // Create attachment with data 'img' and parentId 'recordId'
            n = new Attachment();
            n.Name = 'qrCode.png';
            n.Body = data;
            n.contentType = 'image/png';
            n.ParentId = recordId;
            n.IsPrivate = False;        
            
            // Try to insert the new attachment
            sp = Database.setSavepoint();
            Database.SaveResult sr = Database.insert(n, true);
            
            // If success, return true.
            // else, roll back db status to previous point.
            if(sr.isSuccess())
            	returnValue = True;
            else
                Database.rollback(sp);
        }        
        // Return insertion status
        return returnValue;
    }
    
    
    public static boolean execute(Id recordId, String data) {
        Boolean status = False;
        if( data != null && data != '' && recordId != null) {
           	Blob img = getImageAsBlob(data);
        	status = saveImageToRecordAsAttachment(recordId, img); 
        }
        return status;
    }
}