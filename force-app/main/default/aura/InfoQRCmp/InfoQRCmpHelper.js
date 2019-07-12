({
	retrieveInfoQRList : function(cmp) {
		var action = cmp.get("c.getQRInfoList");
        action.setParams({ recordId : cmp.get("v.recordId") }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            switch(state) {
                case "SUCCESS":
                    var returnValue = response.getReturnValue();
                    cmp.set("v.qrInfoList", returnValue);
                    break;
                default:
                    console.log('Error during callout to InfoSocisAppController.getQRInfoList(Id) in InfoQRCmp. State: ' + state);
                    break;
            }
        });
        $A.enqueueAction(action);
	}
})