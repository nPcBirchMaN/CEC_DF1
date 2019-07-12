({
	Mail2Vocal : function(component, event, helper) 
    {
        var prodId = component.get("v.recordId"); //Recuperamos el ID del productoS
        var action = component.get("c.MailVocal"); //Recuperamos el puntero del método del Apex
        //action.setParams({ProdId:prodId, Modo:'Alta'}); //Añadimos los parámetros que necesita
        action.setParams({ProdId:prodId}); //Añadimos los parámetros que necesita
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") 
            {
                component.set("v.message",response.getReturnValue()); //Mostramos el mensaje Finalizado
                $A.get('e.force:refreshView').fire(); //Refresca la pantalla
            }
        });
        $A.enqueueAction(action); //Invocamos el método del Apex
	}
})