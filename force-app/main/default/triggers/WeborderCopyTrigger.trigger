trigger WeborderCopyTrigger on Web_Order__c (before insert, after update, before delete) {
	if(Trigger.IsInsert  && Trigger.isBefore && !HandlerOpportunityWebOrder.isUpdating){
		system.debug('isInsert' + Trigger.isInsert);
		HandlerOpportunityWebOrder.AddOpporunityFromWebOrder(Trigger.new);
	}
	if(Trigger.IsUpdate  && Trigger.isAfter && !HandlerOpportunityWebOrder.isUpdating){
		system.debug('isUpdate' + Trigger.isUpdate);
		HandlerOpportunityWebOrder.updateOpporunityFromWebOrder(Trigger.new);
	}
	if(Trigger.isDelete && Trigger.isBefore && !HandlerOpportunityWebOrder.isUpdating){
		system.debug('trigger is Delete' + Trigger.isDelete);
		HandlerOpportunityWebOrder.deleteOpporunityFromWebOrder(Trigger.old);
	}
}