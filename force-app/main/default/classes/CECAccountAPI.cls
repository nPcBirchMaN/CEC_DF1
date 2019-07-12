public class CECAccountAPI
{

	public class TokenWordpress
	{
		public String username;
		public String password;
	}
	public class Meta {
		public String cec_membership_number;
	}
	public class UserWordpress
	{
		public string username;//login name REQUIRED
		public string name;//Display name for the user.
		public string first_name;
		public string last_name;
		public string email; //REQUIERED
        public string password;
		public List<String> roles;
		public Meta meta;
	}

    public class AccountChangesData
	{
		public string first_name;
		public string last_name;
        public CECAccountAPI.BillingData billing;
		public List<Map<String, String>> meta_data = new List<Map<String, String>>();
	}
    
    public class BillingData
	{
        public string first_name;
		public string last_name;
		public string address_1;
		public string address_2;
        public string city;
        public string state; //ISO code or name of the state, province or district
        public string postcode;
        public string country; //ISO code
        public string phone;    
	}
    
	public class Data_Z
    {
        public TokenWordpress tokenWordpress;
        public String token;
        public UserWordpress userWordpress;
        public Decimal id;
    }


    public static Data_Z parse(String json)    
    {
        return (Data_Z) System.JSON.deserialize(json, Data_Z.class);
    }

}