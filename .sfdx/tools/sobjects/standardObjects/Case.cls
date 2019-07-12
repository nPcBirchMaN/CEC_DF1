// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Case {
    global Account Account;
    global Id AccountId;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CaseComment> CaseComments;
    global List<CaseContactRole> CaseContactRoles;
    global String CaseNumber;
    global List<CaseSolution> CaseSolutions;
    global List<Case> Cases;
    global Datetime ClosedDate;
    global List<CombinedAttachment> CombinedAttachments;
    global String Comments;
    global Contact Contact;
    global String ContactEmail;
    global String ContactFax;
    global Id ContactId;
    global String ContactMobile;
    global String ContactPhone;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Id Derivada__c;
    global Empleados__c Derivada__r;
    global String Description;
    global List<EmailMessage> EmailMessages;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<CaseFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<CaseHistory> Histories;
    global Id Id;
    global Boolean IsClosed;
    global Boolean IsDeleted;
    global Boolean IsEscalated;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global String N_mero_de_documento__c;
    global List<OpenActivity> OpenActivities;
    global String Origin;
    global SObject Owner;
    global Id OwnerId;
    global Case Parent;
    global Id ParentId;
    global List<SocialPost> Posts;
    global String Priority;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global String Reason;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<ContentDistribution> RelatedRecord;
    global List<CaseShare> Shares;
    global String Status;
    global String Subject;
    global String SuppliedCompany;
    global String SuppliedEmail;
    global String SuppliedName;
    global String SuppliedPhone;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<CaseTeamMember> TeamMembers;
    global List<CaseTeamTemplateRecord> TeamTemplateRecords;
    global List<TopicAssignment> TopicAssignments;
    global String Type;

    global Case () 
    {
    }
}