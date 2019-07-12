({
    getTotal : function(cmp) {
        var prodId = cmp.get('v.recordId'); //Recuperamos el ID del producto
        var action = cmp.get('c.getTotalVendidos');
        action.setParams({ProdId:prodId}); //Añadimos los parámetros que necesita
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.total', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getData : function(cmp) {
        var prodId = cmp.get('v.recordId'); //Recuperamos el ID del producto
        var action = cmp.get('c.getOrdersFromProductId');
        action.setParams({ProdId:prodId}); //Añadimos los parámetros que necesita
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.linPedido', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})