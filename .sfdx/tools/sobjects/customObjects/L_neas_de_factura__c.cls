// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class L_neas_de_factura__c {
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Double Cantidad__c;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Descripci_n_del_producto__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global Id Factura__c;
    global Factura__c Factura__r;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ContentVersion> FirstPublishLocation;
    global List<L_neas_de_factura__History> Histories;
    global Id Id;
    global Double Importe__c;
    global Double Importe_sin_impuestos__c;
    global String Impuesto_texto__c;
    global Double Impuestos__c;
    global Boolean IsDeleted;
    global Date LastActivityDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Boolean Lloc_de_trobada__c;
    global String Name;
    global String Nombre_alternativo__c;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global String Observaciones_del_producto__c;
    global List<OpenActivity> OpenActivities;
    global List<FeedItem> Parent;
    global Decimal Precio_unitario__c;
    global Double Precio_unitario_sin_impuestos__c;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global Id Producto__c;
    global Product2 Producto__r;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String Tipo_de_impuesto__c;
    global String Tipo_de_producto__c;
    global List<TopicAssignment> TopicAssignments;
    global Double Valores_timpuesto__c;

    global L_neas_de_factura__c () 
    {
    }
}