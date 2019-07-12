({
	NuevoVencimiento: function(component, event, helper) {
        var FacturaId = component.get("v.recordId"); //Recuperamos el ID de la factura
        var NumCuotas = component.get("v.numCuotas"); //Recuperamos los datos de las cuotas
        if(NumCuotas>0 && NumCuotas<=12){
        	var action = component.get("c.createVencimientos"); //Recuperamos el puntero del método del Apex
        	action.setParams({FactId:FacturaId, numCuotas:NumCuotas}); //Añadimos los parámetros que necesita
        	action.setCallback(this, function(response){
            	var state = response.getState();
            	if(component.isValid() && state === "SUCCESS"){
                    component.set("v.message",response.getReturnValue());//Mostramos el mensaje 
                    $A.get('e.force:refreshView').fire(); //Refresca la pantalla del pedido
                }
                
        //else{event.getSource().set("v.disabled", true)}
        	});
        	$A.enqueueAction(action); //Invocamos el método del Apex
		}
    
	}
})