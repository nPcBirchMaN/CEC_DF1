public without sharing class ImpresionCarnetExtension {

    private final Account acc;

    public ImpresionCarnetExtension(ApexPages.StandardController stdController) {
        this.acc = (Account)stdController.getRecord();
    }

    public Id getAttachmentId() {
        Id qrId = null;
        
        List<Attachment> attachmentList = [SELECT id FROM attachment WHERE parentId =: acc.id AND name =: 'qrCode.png' LIMIT 1];
        if(!attachmentList.isEmpty())
            qrId = attachmentList[0].id;
        
        return qrId;
    }
}