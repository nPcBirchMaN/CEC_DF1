trigger actualizaPrecioswooCommerce on OrderItem (after insert) {
	if (Trigger.isInsert && Trigger.isAfter)
    {
        /*System.debug('verificamos integridad de precios');
        List<OrderItem> orderItemList = new List<OrderItem>();

        System.debug('Tamaño SET:'+orderIntegrityId.size());
        orderItemList = [SELECT Id,Product2Id,UnitPrice,CategoriaCliente__c from OrderItem where OrderId IN :orderIntegrityId];
        System.debug('Tamaño SET:'+orderItemList.size());*/
        List<OrderItem> orderItemList2Upd = new List<OrderItem>();
        Map<Id,Decimal> orderIntegrityId = new Map<Id,Decimal>();
        String categoria;
        decimal price=0.0;
        for(OrderItem oi:Trigger.New)
        {
            System.debug('Categoria cliente:'+oi.CategoriaCliente__c);
            if(oi.CategoriaCliente__c=='No_soci' || oi.CategoriaCliente__c=='Menor No soci') 
				categoria='No socio';
			if(oi.CategoriaCliente__c=='Participatiu')
				categoria='Socio participativo';
			if(oi.CategoriaCliente__c=='Ple_dret' || oi.CategoriaCliente__c=='Menor')
            	categoria='Socios';
            
            System.debug('Lista a aplicar:'+categoria);
            List<PriceBookentry> pBE = [SELECT Name,Pricebook2Id,Product2Id,UnitPrice,Pricebook2.Name FROM PricebookEntry where Product2Id=:oi.Product2Id]; 
            System.debug('Tamaño:'+pBE.size());
           	for (PriceBookEntry pr:pBE)
            {
                if(pr.Pricebook2.Name==categoria)
                {
                    price=pr.UnitPrice;
                    System.debug('Precio cetegoria:'+price);
                    break;
                }
                else if(pr.Pricebook2.Name=='Standard Price Book')
                {
                    price=pr.UnitPrice;
                    System.debug('Precio standard:'+price);
                }
                
            }
            System.debug('Precio final:'+price);
			//oi.UnitPrice = price;
            orderIntegrityId.put(oi.Id,price);
			//update(oi);
        }
        //Database.update(oi,false);
        orderItemList2Upd = [SELECT Id,UnitPrice from OrderItem where Id IN :orderIntegrityId.keyset()];
        System.debug('Tamañor;:'+orderItemList2Upd.size());	
        for(OrderItem oItemp:orderItemList2Upd)
        {
            oItemp.UnitPrice=orderIntegrityId.get(oItemp.Id);
        }
        update(orderItemList2Upd);
    }
}