({
	doInit : function(component, event, helper) {
        helper.MAX_QUANTITIES = {};
        component.set("v.columns", helper.COLUMN_HEADERS);
        helper.search(component);
	},
    handleSearch : function(component, event, helper) {
        var searchText = component.get('v.searchText');
        component.set('v.changeBySearch', (searchText.length > 0));
        helper.search(component);
    },
    handleTableSave : function(component, event, helper) {
        helper.handleTableSave(component);
    },
    handleSelectedRow : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var orderItemSelected = [];
        var orderItemSelectedObject = [];
        var changeBySearch = component.get("v.changeBySearch");
		
        if(!changeBySearch) {
            // if is there any row selected, store it.
        	for (var i = 0; i < selectedRows.length; i++){
        		orderItemSelected.push(selectedRows[i].Id);
                //orderItemSelectedObject.push({'Id':selectedRows[i].Id, 'Quantity':selectedRows[i].Quantity, 'RefundPrice' : selectedRows[i].RefundPrice});
        		orderItemSelectedObject.push(helper.TEMP_DATA[selectedRows[i].Id]);
            }
        	
            console.log('handleSelectedRow');
            console.log(orderItemSelectedObject);
            
        	component.set('v.orderItemSelected', orderItemSelected);
        	component.set('v.orderItemSelectedObject', orderItemSelectedObject);
            
        	// Enable/disable save button.
        	orderItemSelected = component.get('v.orderItemSelected');    
            component.set('v.disabledSave', (orderItemSelected.length == 0));
        }
        
        component.set('v.changeBySearch', false);
        
		
    },
    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    save : function(component, event, helper) {
		helper.processOrderItems(component);
    }
})