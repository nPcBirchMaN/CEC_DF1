public class CancelOrderController {
    public virtual class OrderException extends Exception {}
    public virtual class OrderItemException extends Exception {}
	public virtual class InvoiceException extends Exception {}
    public virtual class ProductException extends Exception {}
    
    class OrderItemJSONEnvelope {
        public Id ID;
        public Integer REFUND_QUANTITY;
        public Double REFUND_PRICE;
    }
    class ReturnValue {
        public String title;
        public String message;
        public String severity;
        
        public ReturnValue() {
            title = 'Rectificación creada.';
            message = 'La rectificación de facturas ha finalizado con éxito. Se ha enviado un email al cliente.';
            severity = 'success';
        }
    }
    
    @AuraEnabled
    public static String process(Id orderId, String jsonString) {
        ReturnValue retValue = new ReturnValue();
        Savepoint sp = Database.setSavepoint();
        
		// process JSON String to cast into an orderItem envelope.        
        Map<Id, OrderItemJSONEnvelope> jsonOrderItemMap = preprocess(jsonString);
    	System.debug('JSON = ' + jsonOrderItemMap);
        if(!jsonOrderItemMap.isEmpty()) {
            List<OrderItem> oiList = [SELECT id, L_nea_Anulada__c, Product2.Id, Product2.Name, Product2.Plazas_disponibles__c, Quantity, UnitPrice, Product2.tax_class__c, TotalPrice FROM OrderItem WHERE id IN :jsonOrderItemMap.keySet()];

            Order o = [SELECT id, AccountId, Account.PersonEmail, OrderNumber, Contiene_L_neas_Anuladas__c, Etapa__c FROM Order WHERE id = :orderId];
            
            try {
            	// Create Rectificative Invoice.
                Factura__c f = createRectificativeInvoice(o);
                    
                // Create InvoiceLineItems.
                Integer rectificatedCount = createRectificativeInvoiceLineItems(f, o, oiList, jsonOrderItemMap);
                    
                // Create vencimientos.
                createVencimientos(f);
                    
                // Update Order.
                updateOrder(o, rectificatedCount);
                
                // Update OrderItems
                updateOrderItems(oiList, jsonOrderItemMap);
                
                // Update Products
                updateProducts(oiList, jsonOrderItemMap);
                    
                // Update woocomerce stock.
                updateWooComerceProduct(jsonString);
                    
                // Send Emails.
                sendEmails(o, oiList);
            } 
            catch(Exception e) {
                retValue.title = 'Error al crear facturas rectificativas.';
                retValue.message = e.getMessage();
                retValue.severity = 'error';
                System.debug('Exception CancelOrderController :: ' + e.getMessage());
                
                // Undo DML operations.
                Database.rollback(sp);     
            }
        } else {
            retValue.title = 'Error al crear facturas rectificativas.';
            retValue.message = 'Es necesario seleccionar Productos de pedido para poder generar facturas rectificativas.';
            retValue.severity = 'error';
        }
        
        return JSON.serialize(retValue);
    }
    
    private static Map<Id, OrderItemJSONEnvelope> preprocess(String jsonString) {
        Map<Id, OrderItemJSONEnvelope> jsonOrderItemMap = new Map<Id, OrderItemJSONEnvelope>();
        
        system.debug('atPreprocess: ' + jsonString);
        
        List<OrderItemJSONEnvelope> orderItemJSONList = (List<OrderItemJSONEnvelope>)JSON.deserialize(jsonString, List<OrderItemJSONEnvelope>.class);
        
       	for(OrderItemJSONEnvelope oiJSON: orderItemJSONList) {
        	jsonOrderItemMap.put(oiJSON.Id, oiJSON);
        }
        
        System.debug(jsonOrderItemMap);
        return jsonOrderItemMap;
    }
    
    private static Factura__c createRectificativeInvoice(Order o) {
        Factura__c f = new Factura__c();
        
        // Fill rectificative invoice info.
        if(String.isBlank(o.Id)) throw new OrderException('Es necesario informar la cuenta en la Order.');
        f.Id_de_Pedido__c = o.Id;
        f.Cliente__c = o.AccountId;
        f.Name = 'Pedido ' + o.OrderNumber + ' Rectificativa';
        f.Fecha_emisi_n_factura__c = Date.today();
        f.Estado__c = 'Anulada';
        f.Anulaci_n__c = true;
        f.Tipo_de_Factura__c = 'Rectificativa';
        
        // Insert & return;
        Database.insert(f);
        return f;
    }
    
    private static Integer createRectificativeInvoiceLineItems(Factura__c f, Order o, List<OrderItem> oiList, Map<Id, OrderItemJSONEnvelope> jsonOrderItemMap) {
        Integer rectificatedCount = 0;
        Integer quantity;
        List<L_neas_de_factura__c> lfList = new List<L_neas_de_factura__c>();
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        Product2 p;
        
        L_neas_de_factura__c lf;
        
        for(OrderItem oi: oiList) {
            lf = new L_neas_de_factura__c();
            if(String.isBlank(f.Id)) throw new InvoiceException('Es necesario que la factura rectificativa tenga id.');
            lf.Factura__c = f.Id;
            
            if(String.isBlank(oi.Product2Id)) throw new ProductException('Es necesario que el OrderItem tenga asignado un producto.');
            lf.Producto__c = oi.Product2Id;
            
            if(jsonOrderItemMap.containsKey(oi.Id)) {
                quantity = jsonOrderItemMap.get(oi.Id).REFUND_QUANTITY;
                if(quantity > oi.Quantity)
                    throw new OrderItemException('La cantidad del producto ' + oi.Product2.Name + ' a anular no puede ser mayor a ' + oi.Quantity);
                if(quantity < 1) 
                    throw new OrderItemException('La cantidad del producto ' + oi.Product2.Name + ' a anular no puede ser menor a 1');
                    
                lf.Cantidad__c = quantity;
            }
            
            lf.Precio_unitario__c = -1 * jsonOrderItemMap.get(oi.Id).REFUND_PRICE / quantity;
            lf.Tipo_de_impuesto__c = oi.Product2.tax_class__c;
            
            lfList.add(lf);
            rectificatedCount++;            
        }
                
        if(!lfList.isEmpty()) {
            insert lfList;
        }

        return rectificatedCount;
    }
    
    private static void createVencimientos(Factura__c f) {
        f = [SELECT id, Id_de_Pedido__c, Cliente__c, Name, Estado__c, Anulaci_n__c, N_mero_de_factura__c, Tipo_de_Factura__c, Tipo_de_pago__c,
            Fecha_vencimiento__c, Inicio_periodo_facturaci_n__c, Importe_total_factura__c, Cobrada__c, Impagada__c, Fecha_de_pago__c, Fecha_emisi_n_factura__c
            FROM Factura__c WHERE id = :f.id ];
        
        Vencimiento__c v = new Vencimiento__c();
        
        v.Factura__c = f.Id;
        v.Nombre_de_la_factura__c = f.Name;
        v.N_mero_de_Factura__c = f.N_mero_de_factura__c;
        v.Tipo_de_factura__c = f.Tipo_de_Factura__c;
        v.Tipo_de_Pago__c = f.Tipo_de_pago__c;
        v.Inicio_de_Facturaci_n__c = (f.Tipo_de_pago__c == 'Tarjeta' || f.Tipo_de_pago__c == 'Web')? f.Fecha_vencimiento__c : f.Inicio_periodo_facturaci_n__c;
        v.Importe_de_factura__c = f.Importe_total_factura__c;
        v.Importe_Total__c = f.Importe_total_factura__c;
        v.Cobrada__c = f.Cobrada__c;
        v.Impagada__c = f.Impagada__c;
        v.Fecha_de_pago__c = f.Fecha_de_pago__c;
        v.Fin_de_Facturaci_n__c = f.Fecha_emisi_n_factura__c;
        
        insert v;
    }
    
    private static void updateOrder(Order o, Integer rectificatedCount) {
        o.Contiene_L_neas_Anuladas__c = (rectificatedCount > 0);
        update o;
    }
    
    private static void updateOrderItems(List<OrderItem> oiList, Map<Id, OrderItemJSONEnvelope> jsonOrderItemMap) {
        
        for(OrderItem oi: oiList) {
            oi.L_nea_Anulada__c = true;
            System.debug('oi :: ' + oi );
            System.debug('jsonOrderItemMap.get(oi.id) :: ' + jsonOrderItemMap.get(oi.id));
            oi.UnitPrice = (oi.TotalPrice - jsonOrderItemMap.get(oi.id).REFUND_PRICE) / oi.Quantity;
            oi.Description = '['+ Datetime.now() +'] Se han anulado ' + jsonOrderItemMap.get(oi.id).REFUND_QUANTITY + ' unidades de este producto por valor de '+ String.format(jsonOrderItemMap.get(oi.id).REFUND_PRICE.format(),  new String[]{'0','number','###,###,##0.00'})  +'€ a través del botón anulación de pedido.';
        }
        
        if(!oiList.isEmpty()) {
            Database.update(oiList);
        }
    }
    
    private static void updateProducts(List<OrderItem> oiList, Map<Id, OrderItemJSONEnvelope> jsonOrderItemMap) {
        List<Product2> productList = new List<Product2>();
        Product2 p;
        
        for(OrderItem oi: oiList) {
            p = new Product2();
            p.Id = oi.Product2Id;
            // Check if product has plazas disponibles
            if(p.Plazas_disponibles__c <> null && jsonOrderItemMap.get(oi.Id).REFUND_QUANTITY <> null)
            	p.Plazas_disponibles__c = p.Plazas_disponibles__c + jsonOrderItemMap.get(oi.Id).REFUND_QUANTITY;
            productList.add(p);
        }
        
        if(!productList.isEmpty()) {
            Database.update(productList);
        }
    }
    
    @Future(callout=true)
    private static void updateWooComerceProduct(String json) {
        Map<Id, OrderItemJSONEnvelope> jsonOrderItemMap = preprocess(json);
        
        List<OrderItem> oiList = [SELECT id, L_nea_Anulada__c, Product2.Id, Product2.webkul_wws__woo_Post_id__c, Product2.Plazas_disponibles__c, Quantity, Product2.tax_class__c, TotalPrice FROM OrderItem WHERE id IN :jsonOrderItemMap.keySet() AND Product2.webkul_wws__woo_Post_id__c <> NULL AND Product2.Plazas_disponibles__c <> NULL];
        
        Set<Id> productIdSet = new Set<Id>();
        
        for(OrderItem oi: oiList) {
            ProductSynchro.ChangeProductStock(String.valueOf(oi.Product2.webkul_wws__woo_Post_id__c), oi.Product2.Plazas_disponibles__c + jsonOrderItemMap.get(oi.Id).REFUND_QUANTITY, !String.isBlank(String.valueOf(oi.Product2.webkul_wws__woo_Post_id__c)));
        }
        
    }
    
    private static void sendEmails(Order o, List<OrderItem> oiList) {
        PageReference vfPageRef= Page.CancelOrderItemMailTemplate;
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String products = '';
        
        for(Integer i=0; i < oiList.size(); i++) {
            products += oiList[i].product2.Name;
                
            if(i<oiList.size() - 1) 
                products += ';';
            
        }
        vfPageRef.getParameters().put('products', products);
		//message.toAddresses = new String[] { o.Account.PersonEmail, 'daniel.palacios@birchmangroup.com' };
		//message.toAddresses = new String[] { o.Account.PersonEmail, 'melanie.caballero@birchmangroup.com' };
		if(!String.isBlank(o.Account.PersonEmail))
        {
            message.toAddresses = new String[] { o.Account.PersonEmail };
            message.optOutPolicy = 'FILTER';
            message.subject = '[CEC] Inscripcions a activitats cancel·lades.';		
            
            if(!Test.isRunningTest()) message.setHtmlBody(vfPageRef.getContent().tostring());
            else message.setHtmlBody('Mensaje de prueba.');
            
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (!results[0].success) {
                throw new EmailException('El email no ha podido ser enviado.');	
            }
        }
		
    }
    
    @AuraEnabled
    public static OrderItem[] getOrderProducts(Id orderId, String searchKeyword) {
        String keyword = '%' + searchKeyword + '%';
        OrderItem[] retList = [SELECT id, Product2Id, UnitPrice, Product2.Name, TotalPrice, Quantity FROM OrderItem WHERE orderId = :orderId AND Product2.Name LIKE :keyword AND L_nea_Anulada__c = False];
        return retList;
    }
}