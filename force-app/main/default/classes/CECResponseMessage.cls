global class CECResponseMessage 
{   
    global class HandleMessage
    {
        public String salesforceId;
        public String operationalId;
        public String accountNumber;
        public String integrationState;
        public String integrationMessage;
        public Datetime integrationDate;
        public Boolean integrationRetry;
        public Decimal integrationRetryNumber;
    }
    
    public class ResponseMessage 
    {
        public String result;
        public Data data;
        public List<Messages> messages;
    }

    public class Messages 
    {
        public String status;
    }

    public class Data
    {
        //public TotsCustomerData.CustomerData customerData;
        //public TotsContactData.ContactData contactData;
        //public TotsAddressData.AddressData addressData;
        //public TotsProductAttributeData.ProductData productAttributeData;
        //public TotsBrandSubsidiaryData.AffiliateCompanyData affiliateCompanyData;
        //public TotsPriceBookData.PriceListData priceListData;
        //public TotsProjectData.ProjectData projectData;
    }

    
    public static ResponseMessage parse(String json) 
    {
        return (ResponseMessage) System.JSON.deserialize(json, ResponseMessage.class);
    }
}