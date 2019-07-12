({
	recalculoSocios : function(component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
        var toastTitle, toastMessage, toastType;
        
        var action = component.get('c.fireBatchRecalculoSocios');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var success = response.getReturnValue();
                if(success != null && success) {
                    toastTitle = 'Recálculo de socios realizado con éxito.';
                	toastMessage = 'Se ha realizado correctamente el recálculo de socios.';
                	toastType = 'success';
                } else {
                    toastTitle = 'Error en el recálculo de socios.';
                    toastMessage = 'Error en el recálculo de socios. El recálculo no ha podido efectuarse con éxito. Contacte a su administrador.';
                    toastType = 'error';
                }
            } else {
                toastTitle = 'Error en el recálculo de socios.';
                toastMessage = 'Error en el recálculo de socios. No se ha recibido una respuesta correcta del servidor. Contacte a su administrador.';
                toastType = 'error';
            }
            
            toastEvent.setParams({
            	title: toastTitle,
                message: toastMessage,
                type: toastType
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
	},
    generarRemesaRevistaMuntanya : function(component, event, helper) {
        var revista = component.get("v.selectedLookUpRecord"); //Recuperamos el nombre del producto
		var toastEvent = $A.get("e.force:showToast");
        var toastTitle, toastMessage, toastType;
        
        var action = component.get('c.fireBatchGenerarRemesaRevistaMuntanya');
        action.setParams({NombreRevista:revista.Name}); //Añadimos los parámetros que necesita
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var success = response.getReturnValue();
                if(success != null && success) {
                    toastTitle = 'Generación de la remesa de la revista montaña realizada con éxito.';
                	toastMessage = 'Se ha realizado correctamente la generación de la remesa de la revista montaña.';
                	toastType = 'success';
                } else {
                    toastTitle = 'Error en la generación de la remesa de la revista montaña.';
                    toastMessage = 'Error en la generación de la remesa de la revista montaña. La generación de la remesa no ha podido efectuarse con éxito. Contacte a su administrador.';
                    toastType = 'error';
                }
            } else {
                toastTitle = 'Error en la generación de la remesa de la revista montaña.';
                toastMessage = 'Error en la generación de la remesa de la revista montaña. No se ha recibido una respuesta correcta del servidor. Contacte a su administrador.';
                toastType = 'error';
            }
            
            toastEvent.setParams({
            	title: toastTitle,
                message: toastMessage,
                type: toastType
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
	}
})