({
    handleUpdate : function(component, event, helper) {
        var eventParams = event.getParams();
        // If LDS loaded successfully the record, set up iFrame 
        if(eventParams.changeType === "LOADED") {
            var customerId = component.get("v.customerId");
            
            // If ID_CLIENTE__C is propperly filled, call VFP
            if(customerId != null && customerId != "") {
                
                //Send LC Host as parameter to VF page so VF page can send message to LC;
                component.set('v.lcHost', window.location.hostname);
                
                // iFrameUrl setting.
                var iFrameUrl = "/apex/qrpage?data=" + customerId + "&recordId=" + component.get('v.recordId');
                component.set('v.iframeUrl', iFrameUrl); 
                console.log('iFrame Url :: ' +iFrameUrl);
            }     
        }
    }    
})