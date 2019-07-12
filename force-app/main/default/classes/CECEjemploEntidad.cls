public class CECEjemploEntidad 
{

    public class SystemData 
    {
        public String creationDate;
        public String createdById;
        public String lastUpdateDate;
        public String lastUpdateBy;
    }

    public class HijoData //Carol!!! Mira abajo y entenderás este mensaje
    {
        
        public String typeCode;
        public String amount;
        public String currencyCode;
        public String source;
        public String sourceCode;
        public String sourceDate;
        public String status;
        public String documentCode;
        public String documentDate;
        public String bugdetHeading;
        public String budgetCategory;
        public String vendorName;
        public String customerOrder;
        public String uniqueKey;

    }

    public class PadreData 
    {
        public String id;
        public String salesforceId;
        public String href;
        public String description;
        public String owner;
        //public AdditionalData additionalData;
        public List<HijoData> hijoData; //Carol!!!! Esto no va a ser necesario
        public SystemData systemData;
    }

    public class PadreData_Z
    {
        public PadreData padreData;
    }

    
    public static PadreData_Z parse(String json) 
    {
        return (PadreData_Z) System.JSON.deserialize(json, PadreData_Z.class);

    }
}