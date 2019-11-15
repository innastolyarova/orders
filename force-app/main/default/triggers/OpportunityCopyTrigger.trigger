trigger OpportunityCopyTrigger on Opportunity (after insert, after update, before delete) {
	if(Trigger.isInsert  && Trigger.isAfter && !HandlerOpportunityWebOrder.isUpdating){
		HandlerOpportunityWebOrder.addWebOrderFromOpporunity(Trigger.new);
		system.debug('trigger is Update' + Trigger.isUpdate);
        system.debug('trigger is Insert' + Trigger.isInsert);
	}
	if(Trigger.isUpdate &&  Trigger.isAfter && !HandlerOpportunityWebOrder.isUpdating){
		HandlerOpportunityWebOrder.updateWebOrderFromOpporunity(Trigger.new);
	}
	if(Trigger.isDelete && Trigger.isBefore && !HandlerOpportunityWebOrder.isUpdating){
		system.debug('trigger is Delete' + Trigger.isDelete);
		HandlerOpportunityWebOrder.deleteWebOrderFromOpporunity(Trigger.old);
	}

}