public with sharing class QRCodeSaverController {
    @TestVisible
    private static blob getImageAsBlob(String data) {
        // Substract b64 data
        data = data.substringAfter(',');
        // Decode as blob
        blob img = EncodingUtil.base64Decode(data);
        // Return image as blob
        return img;
    }
    @TestVisible
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
    
    @AuraEnabled
    public static boolean ejecutar(Id recordId, String data) {
        Boolean status = False;
        if( data != null && recordId != null) {
           	Blob img = getImageAsBlob(data);
        	status = saveImageToRecordAsAttachment(recordId, img); 
        }
        return status;
    }
}