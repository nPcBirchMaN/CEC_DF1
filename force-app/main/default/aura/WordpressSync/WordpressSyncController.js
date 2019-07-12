({
	AccountSync : function(component, event, helper) {
        var accountId = component.get("v.recordId"); //Recuperamos el ID del account
        var action = component.get("c.AccountSynchronization"); //Recuperamos el puntero del método del Apex
        action.setParams({AccountID:accountId, Modo:'Alta'}); //Añadimos los parámetros que necesita
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.message",response.getReturnValue()); //Mostramos el mensaje Finalizado
                $A.get('e.force:refreshView').fire(); //Refresca la pantalla del pedido
            }
        });
        $A.enqueueAction(action); //Invocamos el método del Apex
	}
})