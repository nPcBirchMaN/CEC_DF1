({
	initComponent : function(component, event, helper) {
		var productId = component.get("v.recordId");
        var action = component.get("c.getStockAndSold");
        action.setParams({ productId : productId});
        action.setCallback(this, function(response) {
            var status = response.getState();
            var productData = response.getReturnValue();
            switch(status) {
                case 'SUCCESS':
                    if(productData === null){
                        console.log("Status code :: " + status);
                        console.log("productData :: " + productData);
                        console.log("APEX controller is returning null productData.");
                        component.set("v.errorInfo", "Ha habido un problema de comunicación con el servidor externo. Contacte a su administrador.");
                        component.set("v.isError", true);
                    } else {
                        component.set("v.productData", productData);
                        var counter = { var: 0 };
                        TweenMax.to(counter, 3, {
                    		var: productData.stock_quantity, 
                        	onUpdate: function () {
                        		component.set("v.productCount", Math.ceil(counter.var));
                        },
                        ease:Circ.easeOut
                    	});
                        
                        component.set("v.isError", false);
                         $A.get('e.force:refreshView').fire(); //Refresca la pantalla del pedido
                    }
                    component.set("v.isLoaded", true);
                    break;
                default:
                    console.log("Status code :: " + status);
                    component.set("v.errorInfo", "Ha habido un problema de comunicación con el servidor externo. Contacte a su administrador.");
                    component.set("v.isError", true);
                    break;
            }
        });
        $A.enqueueAction(action);
	}
})