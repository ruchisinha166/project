public without sharing class LeadTriggerHandler {
    public static void preventDeletion(List<Lead> leads){
        try{
            final String ERROR_MESSAGE = 'You do not have permission to delete record!!';
            String ProfileToBypass = System.label.BypassleadDeletionProfile;
            Profile p = [Select Name from Profile where id = :userinfo.getProfileId()];
            for(Lead ld : leads){
                if(ProfileToBypass!=p.Name){
                    ld.addError(ERROR_MESSAGE);
                }
            }
        }
        Catch(Exception ex){
            System.debug('Error Message--'+ex.getMessage()+'##in line number--'+ex.getLineNumber());
        }
    }
   

}