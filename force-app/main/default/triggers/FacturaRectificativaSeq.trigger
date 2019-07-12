trigger FacturaRectificativaSeq on Factura__c (before insert) 
{
	//por cada nueva factura de tipo rectificativa
	List<Factura_rectificativa_seq__c> listSeq = new List<Factura_rectificativa_seq__c>();
    Map<Integer,Id> setSqeId = new Map<Integer,Id>();
    integer i=0;
    integer j=0;
	for(Factura__c fact :Trigger.New)
    {
        if(fact.Tipo_de_Factura__c=='Rectificativa')
        {
            //hacemos un insert en el objeto de factura seq para obtener su número
            Factura_rectificativa_seq__c seq = new Factura_rectificativa_seq__c();
            //insert(seq);
            listSeq.add(seq);
			
        }
    }
    insert(listSeq);
    for(Factura_rectificativa_seq__c lis:listSeq)
    {
        setSqeId.put(i,lis.Id);
        i++;
    }
    for(Factura__c fact1 :Trigger.New)
    {
        if(fact1.Tipo_de_Factura__c=='Rectificativa')
        {
            fact1.Id_Factura_seq__c=setSqeId.get(j);
            fact1.Anulaci_n__c=true;
            j++;
        }
    }
    
}