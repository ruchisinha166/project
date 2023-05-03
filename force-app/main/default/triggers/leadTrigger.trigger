trigger leadTrigger on Lead (before delete) {
    if(Trigger.isBefore && Trigger.isDelete){
        LeadTriggerHandler.preventDeletion(trigger.new);
    }
}