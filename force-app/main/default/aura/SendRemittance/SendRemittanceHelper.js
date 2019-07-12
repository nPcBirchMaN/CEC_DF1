({
	send : function(component) {
		var action = component.get("c.sendToEmail"); 
        var email = component.get("v.email");
        var dueDate = new Date(component.get("v.dueDate"));
        
        console.log(email);
        console.log(dueDate);
        //var datestring = dueDate.getDate()  + "/" + (dueDate.getMonth()+1) + "/" + dueDate.getFullYear();
        action.setParams({ email : email,
                           remittanceDate : dueDate
                         });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var title, message, type;
            var toastEvent = $A.get("e.force:showToast");
            switch(state) {
                case "SUCCESS":
                    var successfulOperation = response.getReturnValue()
                    if(successfulOperation) {
                        title = "Operación finalizada con éxito.";
                        message = "Un email ha sido enviado con la remesa en formato XML.";
                        type = "success";
                    } else {
                        title = "Operación finalizada sin éxito.";
                        message = "La operación no pudo ser ejecutada con éxito. Contacte un administrador.";
                        type = "error";
                    }
                    break;
                default:
                    title = "Operación finalizada sin éxito.";
                    message = "La operación no pudo ser ejecutada con éxito. Contacte un administrador.";
                    type = "error";
                    break;
            }
            toastEvent.setParams({
        		"title": title,
        		"message": message,
                "type": type
    		});
            toastEvent.fire();
        });
        $A.enqueueAction(action);
	}
})