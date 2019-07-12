({
	FinishOrder : function(component, event, helper) {
        var orderId = component.get("v.recordId"); //Recuperamos el ID del producto
        var action = component.get("c.CheckOrderProductsStock"); //Recuperamos el puntero del método del Apex
        action.setParams({OrderId:orderId}); //Añadimos los parámetros que necesita
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.message",response.getReturnValue()); //Mostramos el mensaje Finalizado
            }
        });
        $A.enqueueAction(action); //Invocamos el método del Apex
	}
})