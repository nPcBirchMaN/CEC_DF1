({
	// Performs the search 
    COLUMN_HEADERS: [
        {label: 'Producto', fieldName: 'ProductNameLink', type: 'url', sortable:false, fixedWidth: 175 , typeAttributes: 
         	{ label: {fieldName: 'ProductName'}, target: '_blank' }},
        {label: 'Importe total', fieldName: 'TotalPrice', type: 'currency', typeAttributes: { currencyCode: 'EUR'}, editable: false, fixedWidth: 135},
        {label: 'Devolución', fieldName: 'RefundPrice', type: 'currency', editable: true, typeAttributes: { currencyCode: 'EUR'}, fixedWidth: 115},
        {label: 'Cantidad', fieldName: 'Quantity', type: 'number', editable: true, fixedWidth: 110}
    ],
    // Stores max quantities for each OrderItem.
    TEMP_DATA: {},
    search : function(component) {
        var orderId = component.get("v.recordId");
        var searchText = component.get('v.searchText');
      	var action = component.get('c.getOrderProducts');
        var self = this;
        
      	action.setParams({'orderId': orderId, 'searchKeyword': searchText});
      	action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var orderItemSelected = component.get("v.orderItemSelected");
                var sObjectList = response.getReturnValue();
				var firstSearch = component.get("v.firstSearch");
                var orderItemTable = component.find("orderItemTable");
                var data = {};
                
                for(var sObject of sObjectList){
                    // Set lightning:datatable hidden parameters.
                    sObject.ProductName = sObject.Product2.Name;
                    sObject.ProductNameLink = '/' + sObject.Product2Id;
                    
                    // If it is the first search, store quantity as maximum quantity.
                    if(firstSearch) {
                        self.TEMP_DATA[sObject.Id] = {'ID': sObject.Id, 'MAX_REFUND' : sObject.TotalPrice, 'MAX_QUANTITY' : sObject.Quantity, 'REFUND_QUANTITY': 1, 'REFUND_PRICE': sObject.TotalPrice}; 
                    }
                    sObject.RefundPrice = self.TEMP_DATA[sObject.Id].REFUND_PRICE;
                    sObject.Quantity = self.TEMP_DATA[sObject.Id].REFUND_QUANTITY;
                }
				orderItemTable.set("v.selectedRows", orderItemSelected);
                component.set("v.data", sObjectList);
                component.set("v.firstSearch", false);
            }
      	});
      	$A.enqueueAction(action);
    },
    processOrderItems : function(component) {
        var orderId = component.get("v.recordId");
        var selectedOrderItems = component.get('v.orderItemSelectedObject');
    	var action = component.get('c.process');
		var self = this;
        
      	action.setParams({'orderId': orderId, 
                          'jsonString': JSON.stringify(selectedOrderItems)
        });
        
        action.setCallback(this, function(response) {
			var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = JSON.parse(response.getReturnValue());
                self.createToast(returnValue.severity, returnValue.title, returnValue.message);
                console.log(returnValue);
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } else {
                self.createToast('warning', 'Ha habido un error', 'Por favor, contacte a su administrador para solventar este problema.');
            }
        });
      	$A.enqueueAction(action);
    },
    handleTableSave : function(component) {
        var draftValues = component.find("orderItemTable").get("v.draftValues");
        var sObjectList = component.get("v.data");
        var orderItemSelectedObject = component.get("v.orderItemSelectedObject");
        
        var messageBody = '';
        var messageTitle = '';
        
        
        for(var draft of draftValues) {
            for(var sObject of sObjectList) {
                if(draft.Id == sObject.Id) {
                    if(draft.Quantity < 1 || draft.Quantity > this.TEMP_DATA[draft.Id].MAX_QUANTITY || draft.Quantity == '') {
                        messageBody = 'La cantidad del producto debe ser como mínimo 1 y menor o igual a ' + this.TEMP_DATA[draft.Id].MAX_QUANTITY;
                        messageTitle = 'La cantidad excede los límites.';
                        component.set("v.messageBody", messageBody);
        				component.set("v.messageTitle", messageTitle);
                        component.set("v.messageVisible", true);
						return;
                    } else if (draft.RefundPrice < 0 || draft.RefundPrice == '' || draft.RefundPrice > this.TEMP_DATA[draft.Id].MAX_REFUND) {
                        messageBody = 'El importe a devolver no puede ser menor a 0€ ni mayor a ' + this.TEMP_DATA[draft.Id].MAX_REFUND +'€.';
                        messageTitle = 'El importe es inferior a 0.';
                        component.set("v.messageBody", messageBody);
        				component.set("v.messageTitle", messageTitle);
                        component.set("v.messageVisible", true);
                    }
                    else {
                        component.set("v.messageVisible", false);
                        if(draft.Quantity != null && draft.Quantity != '') {
                            this.TEMP_DATA[draft.Id].REFUND_QUANTITY = parseInt(draft.Quantity);
                            sObject.Quantity = parseInt(draft.Quantity);
                            alert("Updated Quantity (" + draft.Quantity + ")");
                        }
                        
                        if(draft.RefundPrice != null && draft.RefundPrice != '') {
                            this.TEMP_DATA[draft.Id].REFUND_PRICE = parseInt(draft.RefundPrice);
                        	sObject.RefundPrice = parseFloat(draft.RefundPrice);
                            alert("Updated RefundPrice (" + draft.RefundPrice + ")");
                        }
                        
                        console.log(sObject);
                        console.log(this.TEMP_DATA);
                        break;
                    }
                    
                }
        	}
        }
        
        for(var draft of draftValues) {
            for(var sObject of orderItemSelectedObject) {
                if(draft.Id == sObject.Id) {
                    sObject.Quantity = parseInt(draft.Quantity);
                    break;
                }
        	}
        }
        
        component.set("v.data", sObjectList);
		component.find("orderItemTable").set("v.draftValues", null);
    },
    createToast : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
    		"type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
	}
})