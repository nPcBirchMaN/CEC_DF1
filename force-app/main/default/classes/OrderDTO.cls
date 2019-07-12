public class OrderDTO {
	public string id;
    public string parent_id;
    public string num;
    public string order_key;
    public string created_via;
    public string version;
    public string status;
    public string cur;
    public string date_created;
    public string date_created_gmt;
    public string date_modified;
    public string date_modified_gmt;
    public string discount_total;
    public string discount_tax;
    public string shipping_total;
    public string shipping_tax;
    public string cart_tax;
    public string total;
    public string total_tax;
    public string prices_include_tax;
    public string customer_id;
    public string customer_ip_address;
    public string customer_user_agent;
    public string customer_note;
    
    public string payment_method;
    public string payment_method_title;
    public string transaction_id;
    public string date_paid;
    public string date_paid_gmt;
    public string date_completed;
    public string date_completed_gmt;
    public string cart_hash;
        
    public BillingDTO billing;
    public ShippingDTO shipping;
    public MetadataDTO[] meta_data;
    public LineItemDTO[] line_items;
}