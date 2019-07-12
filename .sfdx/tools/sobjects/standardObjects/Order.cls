// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Order {
    global Account Account;
    global Id AccountId;
    global User ActivatedBy;
    global Id ActivatedById;
    global Datetime ActivatedDate;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Address BillingAddress;
    global String BillingCity;
    global String BillingCountry;
    global String BillingGeocodeAccuracy;
    global Double BillingLatitude;
    global Double BillingLongitude;
    global String BillingPostalCode;
    global String BillingState;
    global String BillingStreet;
    global String Categor_a_del_Cliente__c;
    global Boolean Cerrado__c;
    global String Cliente__c;
    global List<CombinedAttachment> CombinedAttachments;
    global User CompanyAuthorizedBy;
    global Id CompanyAuthorizedById;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global Contract Contract;
    global Id ContractId;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Contact CustomerAuthorizedBy;
    global Id CustomerAuthorizedById;
    global String Datos_cuenta__c;
    global String Description;
    global String Direcci_n__c;
    global Date EffectiveDate;
    global List<EmailMessage> Emails;
    global Date EndDate;
    global String Etapa__c;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global String Extras__c;
    global List<Factura__c> Facturas__r;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<OrderFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<OrderHistory> Histories;
    global Id Id;
    global Decimal Importe_con_promoci_n__c;
    global Boolean IsDeleted;
    global Boolean IsReductionOrder;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global Boolean Notificaci_n_interna__c;
    global Boolean Observaciones_enviadas__c;
    global List<OpenActivity> OpenActivities;
    global List<OrderItem> OrderItems;
    global String OrderNumber;
    global List<Order> Orders;
    global List<Order_Woocomerce__c> Orders_Woocomerce__r;
    global Order OriginalOrder;
    global Id OriginalOrderId;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global String Periodo_recurrente__c;
    global String PoNumber;
    global Pricebook2 Pricebook2;
    global Id Pricebook2Id;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global Id Promoci_n__c;
    global Maestro_de_Promociones__c Promoci_n__r;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global Boolean Recurrente__c;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<OrderShare> Shares;
    global Address ShippingAddress;
    global String ShippingCity;
    global String ShippingCountry;
    global String ShippingGeocodeAccuracy;
    global Double ShippingLatitude;
    global Double ShippingLongitude;
    global String ShippingPostalCode;
    global String ShippingState;
    global String ShippingStreet;
    global String Status;
    global String StatusCode;
    global Boolean Stock_contabilizado__c;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String Tipo_de_Pago__c;
    global List<TopicAssignment> TopicAssignments;
    global Decimal TotalAmount;
    global String Type;
    global Id webkul_wws__Placed_By__c;
    global Contact webkul_wws__Placed_By__r;
    global String webkul_wws__Woo_Order_Status__c;
    global String webkul_wws__woo_Actual_Order_Number__c;
    global Decimal webkul_wws__woo_Discount_Cost__c;
    global Double webkul_wws__woo_Order_Number__c;
    global Decimal webkul_wws__woo_Order_Tax__c;
    global String webkul_wws__woo_Shipment_Method__c;
    global Decimal webkul_wws__woo_Total_order__c;
    global Decimal webkul_wws__woo_coupon_Value__c;
    global String webkul_wws__woo_coupon_code__c;
    global Decimal webkul_wws__woo_shipment_cost__c;

    global Order () 
    {
    }
}