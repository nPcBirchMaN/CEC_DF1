trigger Registro on Opportunity (before update)
{
   //list<Vencimiento__c> listavencimiento = new list<Vencimiento__c>();
   // List<Factura__c> listaFacturas = new List<Factura__c>();
   // List<L_neas_de_factura__c> listalineas = new list <L_neas_de_factura__c>();
    
    //for (Opportunity opp: trigger.new){
       // if(trigger.oldmap.get(opp.id).StageName != opp.StageName && opp.StageName == 'Cerrado Éxito'){
            
           // Factura__c Facturanueva = new Factura__c ();
           // Facturanueva.Name='Oportunidad '+opp.N_Oportunidad__c;
           //Facturanueva.Tipo_de_Factura__c = 'Definitva' o 'Proforma';
           // Facturanueva.Fecha_emisi_n_factura__c = Date.today();
          // Facturanueva.Id_de_oportunidad__c = opp.id;
            
           // listaFacturas.add(Facturanueva);                
       // }  
        
   // }
   // if (listaFacturas.size() > 0) {
      //  insert listaFacturas;
        
       // for(factura__C Fn: listaFacturas){  
            
        //  Vencimiento__c  NuevoVencimiento= new Vencimiento__c();
        
       // NuevoVencimiento.Nombre_de_la_factura__c = Fn.Name;
       // NuevoVencimiento.Inicio_de_Facturaci_n__c = Fn.Inicio_periodo_facturaci_n__c;
       // NuevoVencimiento.Tipo_de_factura__c = 'Definitiva';
        //NuevoVencimiento.Factura__c = fn.Id;
        //NuevoVencimiento.N_mero_de_Factura__c = Fn.N_mero_de_factura__c;
       // NuevoVencimiento.Importe_de_factura__c = Fn.Importe_total_factura__c;
       // NuevoVencimiento.Importe_Total__c = Fn.Importe_total_factura__c;
       // NuevoVencimiento.Tipo_de_Pago__c = Fn.Tipo_de_pago__c;
       // NuevoVencimiento.Cobrada__c = Fn.Cobrada__c;
        
        
       // listavencimiento.add(NuevoVencimiento); }
            
            //<Factura__c> NuevoVencimiento = [SELECT Id, name
                                           //  FROM Factura__c
                                          //   WHERE Factura__c =: FactId]; 
       // insert listavencimiento;

        
   // }
   // for (Factura__c Facturanueva: listaFacturas){
        
       // List<OpportunityLineItem> listaLineasOportunidad = [SELECT ID, Unitprice, Quantity, Product2Id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId =:Facturanueva.Id_de_oportunidad__c];
        
        //for (OpportunityLineItem product: listaLineasOportunidad){
            
            //L_neas_de_factura__c lineaproduct = new L_neas_de_factura__c ();
           // lineaproduct.Factura__c = Facturanueva.Id;             
            //lineaproduct.Precio_unitario__c = product.UnitPrice;
            //lineaproduct.Cantidad__c = product.Quantity;
            //lineaproduct.Producto__c = product.Product2Id;
            
           // listaLineas.add (lineaproduct);
            
        //}
    //} 
    //if (listaLineas.size() > 0) {
       // insert listaLineas;
   // }    		                                      
    
}