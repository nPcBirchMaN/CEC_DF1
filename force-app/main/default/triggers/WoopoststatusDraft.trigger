trigger WoopoststatusDraft on Product2 (before insert, before update) {
	for(Product2 p: trigger.new)
    {
        if (Trigger.isInsert) {
            p.webkul_wws__woo_post_Status__c = 'draft';
        }
        else {
            if (p.webkul_wws__woo_post_Status__c == 'publish') {
                p.Estados__c = 'publish';
            }
        }
    }
}