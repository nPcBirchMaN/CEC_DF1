({
    loadOptions: function (cmp, event, helper) {
        var options = [];
        var action = cmp.get("c.getMotivos");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arr = response.getReturnValue() ;
                arr.forEach(function(element) {
                    options.push({ value: element, label: element });
                });
                cmp.set("v.listaValores", options);
                
            }
        });
        $A.enqueueAction(action); 
    },
    DardeBaja : function(component, event, helper) {
        var CuentaID = component.get("v.recordId");
        var elValorSeleccionado = component.get("v.valorEscogido");
            var action = component.get("c.createBajas"); //Recuperamos el puntero del método del Apex
            action.setParams({IdCuenta:CuentaID, valoret:elValorSeleccionado,instantea:false}); //Añadimos los parámetros que necesita
            action.setCallback(this, function(response){
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS"){
                    component.set("v.message",response.getReturnValue());//Mostramos el mensaje
                    $A.get('e.force:refreshView').fire(); //Refresca la pantalla del pedido
                }
                
            });
            
            $A.enqueueAction(action); //Invocamos el método del Apex
    },
    DardeBajaI : function(component, event, helper) {
            var CuentaID = component.get("v.recordId");
            var elValorSeleccionado = component.get("v.valorEscogido");
                var action = component.get("c.createBajas"); //Recuperamos el puntero del método del Apex
        action.setParams({IdCuenta:CuentaID, valoret:elValorSeleccionado,instantea:true}); //Añadimos los parámetros que necesita
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(component.isValid() && state === "SUCCESS"){
                        component.set("v.message",response.getReturnValue());//Mostramos el mensaje
                        $A.get('e.force:refreshView').fire(); //Refresca la pantalla del pedido
                    }
                    
                });
                
                $A.enqueueAction(action); //Invocamos el método del Apex
        }    
})