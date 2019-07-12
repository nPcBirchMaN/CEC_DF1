({
	CancelProduct : function(component, event, helper) {
        var prodId = component.get("v.recordId"); //Recuperamos el ID del producto
        var action = component.get("c.ProductSynchronization"); //Recuperamos el puntero del método del Apex
        action.setParams({ProdId:prodId, Modo:'Cancelar'}); //Añadimos los parámetros que necesita
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