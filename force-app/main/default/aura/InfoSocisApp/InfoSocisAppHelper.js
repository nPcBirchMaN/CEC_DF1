({
	retrieveSObject : function(cmp) {
		var action = cmp.get("c.getRecord");
        action.setParams({ socioId : cmp.get("v.id") });
        action.setCallback(this, function(response) {
			var state = response.getState();
            switch (state) {
                case "SUCCESS":
                    var result = response.getReturnValue();
                    cmp.set("v.object", result);
					break;
                default:
                    console.log('Error during callout to InfoSocisAppController.getRecord(Id) in InfoSocisApp. State: ' + state);
                    break;
            }           
        });
        $A.enqueueAction(action);
	}
})