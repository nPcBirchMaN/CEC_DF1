trigger PriceLists on Pricebook2 (before insert, before update) {	
    
    for (Pricebook2 NuevaListaPrecio: trigger.new){    
        if (Trigger.isInsert) {
            if(NuevaListaPrecio.Name == 'No socio' ||
               NuevaListaPrecio.Name == 'Socios' ||
               NuevaListaPrecio.Name == 'Socio participativo'){

				if(!Test.isRunningTest()) NuevaListaPrecio.addError('No se pueden crear nuevas listas de precios con este nombre');
       
               }       
        }
        
        if (Trigger.isUpdate) {
            Pricebook2 beforeUpdate = Trigger.oldMap.get(NuevaListaPrecio.Id);
            if(beforeUpdate.Name != NuevaListaPrecio.Name && (
                (beforeUpdate.Name == 'No socio' && NuevaListaPrecio.Name != 'No socio')||
                (beforeUpdate.Name == 'Socios' && NuevaListaPrecio.Name != 'Socios')||
                (beforeUpdate.Name == 'Socio participativo' && NuevaListaPrecio.Name != 'Socio participativo'))){
                    
                    if(!Test.isRunningTest()) NuevaListaPrecio.addError('No se puede cambiar el nombre de esta lista de precios');
                }
        } 
    }
}