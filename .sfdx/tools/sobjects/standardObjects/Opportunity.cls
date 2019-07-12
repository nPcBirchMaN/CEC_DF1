// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Opportunity {
    global Account Account;
    global Id AccountId;
    global List<AccountPartner> AccountPartners;
    global List<ActivityHistory> ActivityHistories;
    global Decimal Amount;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Boolean Budget_Confirmed__c;
    global Campaign Campaign;
    global Id CampaignId;
    global Date CloseDate;
    global List<CombinedAttachment> CombinedAttachments;
    global String Comentarios__c;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global Contract Contract;
    global Id ContractId;
    global List<Lead> ConvertedOpportunity;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Description;
    global Boolean Discovery_Completed__c;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global List<Factura__c> Facturas__r;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<OpportunityFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global String Fiscal;
    global Integer FiscalQuarter;
    global Integer FiscalYear;
    global String ForecastCategory;
    global String ForecastCategoryName;
    global String Forma_de_pado__c;
    global Boolean HasOpenActivity;
    global Boolean HasOpportunityLineItem;
    global Boolean HasOverdueTask;
    global List<OpportunityFieldHistory> Histories;
    global Id Id;
    global Decimal Importe_con_promoci_n__c;
    global Boolean IsClosed;
    global Boolean IsDeleted;
    global Boolean IsWon;
    global Date LastActivityDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global String LeadSource;
    global String Loss_Reason__c;
    global String N_Oportunidad__c;
    global String Name;
    global String NextStep;
    global String Nombre_exposici_n__c;
    global String Nombre_fotograf_a__c;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global String Observaciones__c;
    global List<OpenActivity> OpenActivities;
    global List<ForecastingFact> Opportunity;
    global List<OpportunityCompetitor> OpportunityCompetitors;
    global List<OpportunityContactRole> OpportunityContactRoles;
    global List<OpportunityHistory> OpportunityHistories;
    global List<OpportunityLineItem> OpportunityLineItems;
    global List<OpportunityPartner> OpportunityPartnersFrom;
    global String Origen__c;
    global User Owner;
    global Id OwnerId;
    global List<FeedComment> Parent;
    global List<Partner> Partners;
    global Pricebook2 Pricebook2;
    global Id Pricebook2Id;
    global Double Probability;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global Id Productos__c;
    global Product2 Productos__r;
    global Id Promociones__c;
    global Maestro_de_Promociones__c Promociones__r;
    global List<Quote> Quotes;
    global Boolean ROI_Analysis_Completed__c;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<OpportunityShare> Shares;
    global String StageName;
    global Quote SyncedQuote;
    global Id SyncedQuoteId;
    global Datetime SystemModstamp;
    global String Tarifas_especiales__c;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String Tipo_de_pago__c;
    global String Tipologia_c__c;
    global List<TopicAssignment> TopicAssignments;
    global String Type;
    global Boolean factura_generada__c;
    global String webkul_wws__Woo_Order_Status__c;
    global String webkul_wws__Woo_Shipment_Method__c;
    global String webkul_wws__woo_Actual_Order_Number__c;
    global Decimal webkul_wws__woo_Discount_Cost__c;
    global String webkul_wws__woo_Order_Number__c;
    global Decimal webkul_wws__woo_Order_Tax__c;
    global Decimal webkul_wws__woo_Total_order__c;
    global Decimal webkul_wws__woo_coupon_Value__c;
    global String webkul_wws__woo_coupon_code__c;
    global Decimal webkul_wws__woo_shipment_cost__c;

    global Opportunity () 
    {
    }
}