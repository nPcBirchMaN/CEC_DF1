({
	RecalcularSO : function(component, event, helper) {
        var ID = component.get("v.recordId");
        var action = component.get("c.RecalculoSocios"); //Recuperamos el puntero del método del Apex
        action.setParams({RegistroID:ID}); //Añadimos los parámetros que necesita
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
            	component.set("v.message",response.getReturnValue());//Mostramos el mensaje
                }
                
            });
            
            $A.enqueueAction(action); //Invocamos el método del Apex
		
	}
})