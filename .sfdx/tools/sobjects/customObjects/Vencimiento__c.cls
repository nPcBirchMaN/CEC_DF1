// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Vencimiento__c {
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global String BIC_SWIFT__c;
    global String C_digo_pa_s__c;
    global Boolean Cobrada__c;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global Double Ejercicio__c;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global Id Factura__c;
    global Factura__c Factura__r;
    global Date Fecha_de_pago__c;
    global Date Fecha_firma_mandato__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global Date Fin_de_Facturaci_n__c;
    global List<ContentVersion> FirstPublishLocation;
    global List<Vencimiento__History> Histories;
    global String IBAN__c;
    global Id Id;
    global String Id_Vencimiento__c;
    global Boolean Impagada__c;
    global Double Importe_Total__c;
    global Decimal Importe_de_factura__c;
    global Date Inicio_de_Facturaci_n__c;
    global Boolean IsDeleted;
    global Date LastActivityDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global String Motivo_devoluci_n__c;
    global String N_mero_de_Factura__c;
    global Double N_mero_de_pago__c;
    global String Name;
    global String Nombre_de_la_factura__c;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global String Ref_fichero__c;
    global String Referencia__c;
    global String Referencia_fichero__c;
    global String Referencia_mandato__c;
    global String Referencia_recibo__c;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global String Remesa__c;
    global Boolean Remesada__c;
    global String Residente__c;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String Tipo_adeudo__c;
    global String Tipo_de_Pago__c;
    global String Tipo_de_factura__c;
    global List<TopicAssignment> TopicAssignments;

    global Vencimiento__c () 
    {
    }
}