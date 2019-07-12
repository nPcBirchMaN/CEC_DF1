({
	sendRemittance : function(component, event, helper) {
        
        var emailValidity = component.find("emailInput").checkValidity();
        var dateValidity = component.find("dateInput").checkValidity();
        if(emailValidity && dateValidity) {
            helper.send(component);
        } else {
            var toastEvent = $A.get("e.force:showToast");
    		toastEvent.setParams({
        		"title": "Error",
        		"message": "Se debe especificar un email y una fecha.",
                "type": "error"
    		});
    		toastEvent.fire();
        }
	}
})