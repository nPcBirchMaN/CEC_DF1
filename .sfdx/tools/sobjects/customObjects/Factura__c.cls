// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Factura__c {
    global List<ActivityHistory> ActivityHistories;
    global Boolean Anulaci_n__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Double Base_imp_IVA_0__c;
    global Double Base_imp_IVA_10__c;
    global Double Base_imp_IVA_21__c;
    global Double Base_imp_IVA_4__c;
    global Double Base_imposable__c;
    global String CC_IBAN__c;
    global Id Cliente__c;
    global Account Cliente__r;
    global Boolean Cobrada__c;
    global List<CombinedAttachment> CombinedAttachments;
    global String Comentarios__c;
    global Boolean Contabilizada__c;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Boolean Cuota_Socio__c;
    global String Direcci_n__c;
    global String Documento__c;
    global Boolean Donaci_n__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global Double Ejercicio__c;
    global List<EmailMessage> Emails;
    global String Estado__c;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global Boolean Factura_electr_nica__c;
    global Date Fecha_de_cobro__c;
    global Date Fecha_de_pago__c;
    global Date Fecha_emisi_n_factura__c;
    global Date Fecha_vencimiento__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global Date Fin_periodo_facturaci_n__c;
    global List<ContentVersion> FirstPublishLocation;
    global List<Factura__History> Histories;
    global String IBAN__c;
    global Boolean IVA_0_YES__c;
    global Boolean IVA_10_YES__c;
    global Double IVA_10__c;
    global Boolean IVA_21_YES__c;
    global Double IVA_21__c;
    global Boolean IVA_4_YES__c;
    global Double IVA_4__c;
    global Id Id;
    global Id Id_Factura_seq__c;
    global Factura_rectificativa_seq__c Id_Factura_seq__r;
    global Id Id_de_Oportunidad__c;
    global Opportunity Id_de_Oportunidad__r;
    global Id Id_de_Pedido__c;
    global Order Id_de_Pedido__r;
    global Boolean Impagada__c;
    global Double Importe_total_factura__c;
    global Date Inicio_periodo_facturaci_n__c;
    global Boolean IsDeleted;
    global List<L_neas_de_factura__c> L_neas_de_factura__r;
    global String LabelFormaPago__c;
    global Date LastActivityDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global String Motivo_devoluci_n__c;
    global String N_mero_de_factura__c;
    global String N_mero_de_factura_rectificativaCALC__c;
    global String Name;
    global String Nombre_del_titular__c;
    global String Nombre_exposici_n__c;
    global String Nombre_fotograf_a__c;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global String Periodo_de_pago__c;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global String Referencia__c;
    global List<ContentDistribution> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global String Remesa__c;
    global Boolean Remesada__c;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String Tipo__c;
    global String Tipo_de_Factura__c;
    global String Tipo_de_pago__c;
    global String Tipolog_a__c;
    global List<TopicAssignment> TopicAssignments;
    global Decimal Total_IVA_10__c;
    global Decimal Total_IVA_21__c;
    global Decimal Total_IVA_4__c;
    global Double Vencimiento__c;
    global List<Vencimiento__c> Vencimiento__r;
    global String obs__c;

    global Factura__c () 
    {
    }
}