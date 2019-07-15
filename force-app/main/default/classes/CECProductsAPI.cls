public class CECProductsAPI 
{
    
    public class ProductsData 
    {
        public Decimal id;
        public Decimal stock_quantity;
		public Boolean manage_stock; //si hay stock poner a true
        public String idProduct;
        public String status;
        public String description;
        public String short_description;
        public String sku;
        public String name; //titulo
        public String regular_price; //precio no socio
        public Boolean sold_individually;
        public String tax_status;
        public String tax_class;
        //public Boolean virtual;
        public List<Map<String, String>> meta_data = new List<Map<String, String>>();
    }
    
    public class UserRoleData 
    {
        public String customer;
        public String soci;
        public String soci_participatiu;
    }
    
    public class HideUserRoleData 
    {
        public CECProductsAPI.UserRoleData hidePriceForUserRoles = new CECProductsAPI.UserRoleData();
        public String onlyRegisteredUsers;
    }
    
    public class PriceData 
    {
        public String customer;
        public String salePrice;
        public String schedule;
        public String soci;
        public String soci_participatiu;
    }
    
    public class ResponseData 
    {
        public String status;
        public String resource_id;
    } 
    
    public class StockData 
    {
        public Boolean manage_stock;
        public Decimal stock_quantity;
    } 
    
    public class StockResponseData 
    {
        public Decimal id;
        public Decimal stock_quantity;
        public Decimal total_sales;
		public String idProduct;
        public String status;
        public String name; //titulo
        public String code;
    }
    
    public class ProductsData_Z
    {
        public ProductsData ProductsData;
        public Decimal id;
        //public List<WooMetaData> meta_data = new List<WooMetaData>();
        
        //Campos que se reciben cuando falla la sincronización
        public ResponseData data;
        public String code;
        public String message;
    }
    
    public static ProductsData_Z parse(String json)    
    {
        return (ProductsData_Z) System.JSON.deserialize(json, ProductsData_Z.class);
    }

    public static StockResponseData parseStock(String json)    
    {
        return (StockResponseData) System.JSON.deserialize(json, StockResponseData.class);
    }
    
    //Pasamos el producto y rellenamos el ProductData que utilizaremos para sincronizar con wooCommerce
    public static CECProductsAPI.ProductsData RellenarProductDataDesdeProducto (Product2 producto, List<PricebookEntry> priceBookList, String Modo) 
    {
        CECProductsAPI.ProductsData productData = new CECProductsAPI.ProductsData();
        if (Modo == 'Alta') {
            //productData.idProduct = producto.Id;
            productData.id = producto.webkul_wws__woo_Post_id__c;
            productData.name = producto.Name;
            productData.description = producto.Descripci_n_completa__c;
            productData.short_description = producto.Description;
            //productData.description = producto.webkul_wws__Woo_Post_Description__c;
            //productData.short_description = producto.webkul_wws__woo_Post_excerpt__c;
            productData.status = (producto.Estados__c == 'Cancelada') ? 'draft' : producto.Estados__c; //Si el producto se cancela, se pone a draft
            productData.sold_individually = (producto.Product_type__c == 'merchandising') ? false : producto.sold_individually__c; //Si es un producto merchandasing dejamos que puedan comprar más de uno
            //productData.virtual = (producto.Product_type__c == 'merchandising') ? false : true; //Los productos tipo merchandising son físicos por tanto, virtual a false, el resto son virtuales, virtual a true
            
            productData.tax_status = producto.tax_status__c;
            productData.tax_class = producto.tax_class__c;
            
            if (producto.webkul_wws__woo_Post_id__c == null) {
                productData.manage_stock = (producto.Plazas_totales__c != null) ? true : false;                
            	productData.stock_quantity = producto.Plazas_totales__c;
                productData.sku = producto.ProductCode;
            }
            
            //Campos que van en meta_data
            Map<String, String> metaData = new Map<String, String>();
            metaData.put('meeting_data', producto.Datos_de_encuentros__c);
            metaData.put('directed_by', producto.Dirigido_por__c);
            metaData.put('post_status', (producto.Estados__c == 'Cancelada') ? 'draft' : producto.Estados__c); //Si el producto se cancela, se envia a draft
            metaData.put('end_date', String.valueOf(producto.Fecha_de_fin__c));
            //metaData.put('start_date', String.valueOf(producto.Fecha_de_inicio__c));
            if((producto.Product_type__c=='subscription' || producto.Product_type__c=='guide')&&String.valueOf(producto.Fecha_de_inicio__c)==null)
            {
                metaData.put('start_date','2999-12-31');
            }
            else
            {
                metaData.put('start_date', String.valueOf(producto.Fecha_de_inicio__c));
            }
            metaData.put('end_enrolment', String.valueOf(producto.Final_inscripci_n__c));
            metaData.put('start_enrolment', String.valueOf(producto.Inicio_inscripci_n__c));
            metaData.put('difficulty', producto.Grado_de_dificultad__c);
            metaData.put('organizer', producto.Organizador__c);
            metaData.put('previous_meeting', producto.Reuni_n_Previa__c);
            metaData.put('addressed_to_families', String.valueOf(producto.Dirigido_a_familias__c));
            metaData.put('addressed_to_young_people', String.valueOf(producto.Dirigido_a_j_venes__c));
            metaData.put('addressed_to_children', String.valueOf(producto.Dirigido_a_ninos__c));
            metaData.put('addressed_to_seniors', String.valueOf(producto.Dirigido_a_seniors__c));
            metaData.put('cec_product_type', producto.Product_type__c);
            metaData.put('cec_activity_type', producto.Activity_type__c);
            metaData.put('cec_role_to_assign', producto.Role_to_assign__c);
            metaData.put('cec_disc_soci_participatiu', String.valueOf(producto.cec_disc_soci_participatiu__c));
            metaData.put('cec_disc_soci', String.valueOf(producto.cec_disc_soci__c));
            metaData.put('cec_sf_form', (producto.Gu_a_con_formulario_de_contacto__c == true)? 'true' : 'false');
            
            //Obtenemos el listado de coordinadores de la actividad, separado por ','
            String [] coordinadores = new String []{};
            String coordinatedBy = producto.Coordinada_por__c;
            if (coordinatedBy != null && coordinatedBy != '') {
                coordinadores = coordinatedBy.split(';');
                if (coordinadores.size() > 0) {
                    for (Integer i=0; i<coordinadores.size();i++) {
                        coordinadores[i] = coordinadores[i].trim();
                    }
                }
            }
            
            //Insertamos los roles que no podrán comprar el producto
            //Si se inserta alguno, entonces no se podrá comprar el producto si no se ha logado el usuario
            CECProductsAPI.HideUserRoleData hideUserRoleData = new CECProductsAPI.HideUserRoleData();
            CECProductsAPI.UserRoleData userRoleData = new CECProductsAPI.UserRoleData();
            if (producto.Impedir_Compra_No_Socio__c) {
                userRoleData.customer = '1';
                hideUserRoleData.onlyRegisteredUsers = '1';
            }
            if (producto.Impedir_Compra_Socio__c) {
                userRoleData.soci = '1';
                hideUserRoleData.onlyRegisteredUsers = '1';
            } 
            if (producto.Impedir_Compra_Socio_Participativo__c) {
                userRoleData.soci_participatiu = '1';
                hideUserRoleData.onlyRegisteredUsers = '1';
            } 
            hideUserRoleData.hidePriceForUserRoles = userRoleData;
            
            //Insertamos los precios
            CECProductsAPI.PriceData priceData = new CECProductsAPI.PriceData();
            String precioFinal;
            
            for (PricebookEntry priceBook : priceBookList) {
                
                // Ha habido una incidencia, no se actualiza la lista de la compra cuando es 0,
                // por eso se le pone 0.001, para que siga siendo 0 y funcione correctamente.
                if(priceBook.UnitPrice == 0.00) {
                	precioFinal = '0,001';
                } else {
                    precioFinal = String.valueOf(priceBook.UnitPrice);
                }
                
                if (priceBook.Pricebook2.Name == 'Socios' && priceBook.Pricebook2.IsActive == true) { priceData.soci = precioFinal; }
                else if (priceBook.Pricebook2.Name == 'No socio' && priceBook.Pricebook2.IsActive == true) { productData.regular_price = precioFinal; }
                else if (priceBook.Pricebook2.Name == 'Socio participativo' && priceBook.Pricebook2.IsActive == true) { priceData.soci_participatiu = precioFinal; }
            }
            
            //Creamos la lista de metadatas a enviar a wooCommerce
            productData.meta_data = CreateMetaDataList(metaData, priceData, hideUserRoleData, coordinadores);
        }
        else {
            //Cuando el producto es cancelado hay que pasarlo a estado draft en wooCommerce
            productData.id = producto.webkul_wws__woo_Post_id__c;
            //productData.status = 'draft';
            //Añadimos al nombre de la actividad la palabra 'Anulada'
            productData.name = 'Anul·lada '+producto.Name;
            productData.stock_quantity = 0;            
            //Insertamos los roles que no podrán comprar el producto
            CECProductsAPI.UserRoleData userRoleData = new CECProductsAPI.UserRoleData();
            userRoleData.customer = '1';
            userRoleData.soci = '1';
            userRoleData.soci_participatiu = '1';
            CECProductsAPI.HideUserRoleData hideUserRoleData = new CECProductsAPI.HideUserRoleData();
            hideUserRoleData.hidePriceForUserRoles = userRoleData;
            hideUserRoleData.onlyRegisteredUsers = '1';

            List<Map<String, String>> metaDataEnviar = new List<Map<String, String>>();
            //El listado del tipo de usuarios que no pueden ver la actividad
            Map<String, String> metaDataUserRole = new Map<String, String>();
            metaDataUserRole.put('value', JSON.serialize(hideUserRoleData, true));
            metaDataUserRole.put('key', 'festiUserRoleHidenPrices');
            metaDataEnviar.add(metaDataUserRole);
            
            productData.meta_data = metaDataEnviar;
       
        }
        
        return productData;
    }
    public static List<Map<String, String>> CreateMetaDataList (Map<String, String> metaData, CECProductsAPI.PriceData priceData, CECProductsAPI.HideUserRoleData hideUserRoleData, String[] coordinadores) {
        List<Map<String, String>> metaDataEnviar = new List<Map<String, String>>();
        for (String key : metaData.keySet()) {
            Map<String, String> metaDataString = new Map<String, String>();
            metaDataString.put('value', metaData.get(key));
            metaDataString.put('key', key);
            metaDataEnviar.add(metaDataString);
        }
        //El listado de precios para soci y participatiu
        if (priceData != null) {
            Map<String, String> metaDataPrice = new Map<String, String>();
            metaDataPrice.put('value', JSON.serialize(priceData));
            metaDataPrice.put('key', 'festiUserRolePrices');
            metaDataEnviar.add(metaDataPrice);
        }
        //El listado del tipo de usuarios que no pueden ver la actividad
        if (hideUserRoleData != null) {
            Map<String, String> metaDataUserRole = new Map<String, String>();
            metaDataUserRole.put('value', JSON.serialize(hideUserRoleData, true));
            metaDataUserRole.put('key', 'festiUserRoleHidenPrices');
            metaDataEnviar.add(metaDataUserRole);
        }
        //El listado de coordinadores de la actividad
        if(coordinadores != null) {
            Map<String, String> coordinated_by = new Map<String, String>();
            coordinated_by.put('value', JSON.serialize(coordinadores, true));
            coordinated_by.put('key', 'coordinated_by');
            metaDataEnviar.add(coordinated_by);
        }
        return metaDataEnviar;
    }
}