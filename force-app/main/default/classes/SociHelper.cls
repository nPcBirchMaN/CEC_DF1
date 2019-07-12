public class SociHelper {
	private final static Id standardPriceBookId = [select id, name from Pricebook2 where isStandard = true limit 1][0].Id;
    
    public static boolean createAutomaticSubscriptions(List<Account> sociList) {
        boolean returnValue = true;
        List<Order> orderList;
        List<OrderItem> installmentList;
		List<OrderItem> enrolmentList;
        
        try {
            // For every "soci", creates an order.
        	orderList = createAnualInstallmentOrdersFromSociList(sociList);
            
        	// For every order, create the suitable orderItem.
        	installmentList =	createAnualInstallmentOrdersItems(orderList, sociList); 
        	enrolmentList = createEnrolmentList(orderList, sociList);
        } catch(InstallmentException e) {
            Account acc = (Account) e.getSObject();
			acc.addError(e.getMessage());
        } catch(EnrolmentException e) {
            Account acc = (Account) e.getSObject();
            acc.addError(e.getMessage());
        }
        
        
            
        return returnValue;
    }
    
    public static List<Order> createAnualInstallmentOrdersFromSociList(List<Account> sociList) {
        List<Order> orderList = new List<Order>();
        Order o;
        
        // For every "soci", creates an order.
        for(Account soci: sociList) {
            o = new Order();
            System.debug('soci Id ' + soci.Id);
            o.AccountId = soci.Id;
            o.EffectiveDate = Date.today();
            o.Status = 'Draft';
            o.Pricebook2Id = standardPriceBookId;
        	orderList.add(o);    
        }
        if(!orderList.isEmpty())
            Database.insert(orderList);
        
        return orderList;
    }
    
    private static Map<String, Map<String, Product2>> getAnualInstallmentMap() {
        Map<String, Map<String, Product2>> installmentMapByRoleModality = new Map<String, Map<String, Product2>>();
        Map<String, Product2> installmentMapByModality = new Map<String, Product2>();
        
        List<Product2> installmentList = [Select id, Name, Categor_a__c, Role_to_assign__c, Modalidad_a_asignar__c, Product_type__c FROM product2 Where Product_type__c = 'subscription' AND Name LIKE '%Quota anual Soci%'];
		
        for(Product2 installment: installmentList) {
            if(!installmentMapByRoleModality.containsKey(installment.Role_to_assign__c)) {
                installmentMapByRoleModality.put(installment.Role_to_assign__c, new Map<String, Product2>());
            }
            installmentMapByModality = installmentMapByRoleModality.get(installment.Role_to_assign__c);
            installmentMapByModality.put(installment.Modalidad_a_asignar__c, installment);
        }        
        
        return installmentMapByRoleModality;
    }
    
    private static Map<Id, PriceBookEntry> getPriceBookEntriesByProductId(Map<String, Map<String, Product2>> installmentMap) {
        Map<Id, PriceBookEntry> pbeMap = new Map<Id, PriceBookEntry>();
        Set<Id> productIdSet = new Set<Id>();
        
        for(Map<String, Product2> m: installmentMap.values()) {
            for(Product2 p: m.values()) {
                productIdSet.add(p.id);
            }
        }
        
        for(PricebookEntry pbe: [SELECT id, product2Id FROM PriceBookEntry WHERE PriceBook2Id = :standardPriceBookId AND product2Id IN :productIdSet]) {
            pbeMap.put(pbe.product2Id, pbe);
        }
        
        return pbeMap;
    }
    
    private static List<PriceBookEntry> getEnrolmentPriceBookEntry() {
        return [Select id, product2Id, name from pricebookentry where name Like 'Matrícula' and pricebook2.isStandard = True and isActive = true LIMIT 1 ];
    }
    
    public static List<OrderItem> createAnualInstallmentOrdersItems(List<Order> orderList, List<Account> sociList) {
        Map<Id, Account> sociMap = new Map<Id, Account>(sociList);
        List<OrderItem> orderItemList = new List<OrderItem>();
        Map<String, Map<String, Product2>> installmentMap;
        Map<Id, PriceBookEntry> pricebookEntryMapByProductId;
        
        String role, modalidad;
        OrderItem oi;
        Account acc;
        Product2 installment;
        PricebookEntry pbe;
        
        // Retrieve anual installment map
        installmentMap = getAnualInstallmentMap();
        pricebookEntryMapByProductId = getPriceBookEntriesByProductId(installmentMap);
        
        for(Order o: orderList) {
            acc = sociMap.get(o.AccountId);
            oi = new OrderItem();
            
            // Retrieve role
            switch on (acc.Categor_a__c.toLowerCase()) {
                // Underaged
                when 'menor' {
                    role = 'Menor';
                }
                
                // Participative
                when 'participatiu' {
                    role = 'soci_participatiu';
                }
                
                // Socis
                when 'ple_dret' {
                    role = 'soci';
                }
                
            }
            // Retrieve modalidad
            modalidad = acc.Modalidad__c;
            
            // Retrieve suitable product, if does not exist, throw InstallmentException
            if(installmentMap.containsKey(role) && installmentMap.get(role).containsKey(modalidad)) {
                installment = installmentMap.get(role).get(modalidad);
            } else {
                InstallmentException e = new InstallmentException('No existe un producto perteneciente al rol ' + role + ' y a la modalidad ' + modalidad + '. Por favor, crealo y si persiste este error contacte a su administrador.');
                
                e.setSObject(acc);
                
                throw e;
            }
            
            
            if(installment <> null && pricebookEntryMapByProductId.containsKey(installment.id)) {
                pbe = pricebookEntryMapByProductId.get(installment.id);
            	oi.OrderId = o.Id;
            	oi.Product2Id = installment.id;
            	oi.PricebookEntryId = pbe.id;
            	oi.Quantity = 1;
            	oi.UnitPrice = 123456;
                
                orderItemList.add(oi);
            }  
        }
        
        if(!orderItemList.isEmpty())
            Database.insert(orderItemList);
        
        return orderItemList;
    }
    
    public static List<OrderItem> createEnrolmentList(List<Order> orderList, List<Account> sociList) {
        Map<Id, Account> sociMap = new Map<Id, Account>(sociList);
        List<OrderItem> enrolmentList = new List<OrderItem>();
        List<PricebookEntry> enrolment = getEnrolmentPriceBookEntry();
        OrderItem oi;
        Account acc;
        
        // For every Order, generate an enrolment (OrderItem)
        for(Order o: orderList) {
            acc = sociMap.get(o.AccountId);
            
            if(acc.Categor_a__c != 'Menor' && acc.Categor_a__c != 'Participatiu') {
                if (enrolment.isEmpty()) {
                    EnrolmentException e = new EnrolmentException('No existe un producto "Matrícula" activo en la lista de precios estándar. Por favor, crealo y si persiste este error contacte a su administrador.');
                    
                    e.setSObject(acc);
                    
                    throw e;
                }
            	oi = new OrderItem();
            	oi.OrderId = o.Id;
            	oi.PricebookEntryId = enrolment[0].id;
            	oi.Product2Id = enrolment[0].Product2Id;
            	oi.Quantity = 1;
            	oi.UnitPrice = 3;
            	enrolmentList.add(oi);   
            }
        }
        
        if(!enrolmentList.isEmpty())
            Database.insert(enrolmentList);
        
    	return enrolmentList;
    }
}