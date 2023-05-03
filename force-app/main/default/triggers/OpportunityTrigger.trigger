trigger OpportunityTrigger on Opportunity (after update) {
    if(trigger.isafter && trigger.isUpdate){
        FeedbackSurvey.checkAppointment(trigger.new);
    }

}