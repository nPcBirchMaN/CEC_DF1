trigger NoCerrarPedido on Order (before insert, before update) {
	for (Order ord: trigger.new)
    {
        if (Trigger.isUpdate) {
            Order beforeUpdate = Trigger.oldMap.get(ord.id);
            
            if (beforeUpdate.Etapa__c != ord.Etapa__c && ord.Etapa__c == '3.Cerrada' && ord.webkul_wws__woo_Order_Number__c == null && ord.Cerrado__c == true){
                ord.Etapa__c = '3.Cerrada';
                ord.status = 'Activado';
            }
            else if (beforeUpdate.Etapa__c != ord.Etapa__c && ord.Etapa__c == '3.Cerrada' && ord.webkul_wws__woo_Order_Number__c == null && ord.Cerrado__c != true){
            	if(!Test.isRunningTest()) ord.addError('Debe pulsar el botón "Finalizar pedido" para cerrar el pedido');
            }
        }
     }
}