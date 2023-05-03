public class FeedbackSurvey { 
    public static void checkAppointment(List<Opportunity> olist) { 
        List<Id> contactIds= new List<Id>(); 
        List<Id> oppid = new List<id>(); 
        List<String> remail= new List<String>(); 
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
        List<SurveySubject> surveysubjectlist= new List<SurveySubject>(); 
        List<SurveyInvitation> invitationlink= new List<surveyInvitation>(); 
        map<id,id> SurveyInvitationids = new map<id,id>(); 
        map<id,string> surveyInvitationlink = new map<id,string>(); 
        List<id> SurveyInvid =new List<Id>(); 
        map<id,String> accountemail= new map<id,String>(); 
        map<id,String> locationMap = new map<id,String>(); 
        map<id,String> NameMap= new map<id,String>(); 
        Survey surveyidindia =[select id ,Name from survey where Name = :'Survey Feedback Form' LIMIT 1]; 
        Network n= [SELECT Id,Name FROM Network where Name = :'Survey' LIMIT 1]; 
        String Communityid= n.id;
        for(Opportunity thisopportunity : olist ) { 
            contactIds.add(thisopportunity.Practitioner_Name__c); 
            oppid.add(thisopportunity.id); 
        } 
        for(Contact c : [Select id,Name,AccountId,Account.Name,Account.Email__c from Contact where id In :contactIds]) { 
            //locationMap.put(c.id,c.ART_Center_Location__c); 
            accountemail.put(c.id,c.Account.Email__c); 
            NameMap.put(c.id,c.Name); 
        } 
        system.debug('accountname ----'+accountemail); 
        for(Opportunity thisopp : oList) { 
            if(thisopp.Status__c == 'Discharged' && thisopp.Practitioner_Name__c != null) { 
                SurveyInvitation surveyInv = new SurveyInvitation(); 
                surveyInv.Name = 'Survey Feedback Form'; // add your survey invitation name here 
                surveyInv.ParticipantId = thisopp.Practitioner_Name__c; 
                surveyInv.Patient_Case__c = thisopp.id; 
                surveyInv.CommunityId = communityid; //add your community id here 
                surveyInv.OptionsAllowGuestUserResponse = true; 
                surveyInv.SurveyId = surveyidindia.id; 
                invitationlink.add(surveyInv); 
            } 
        } insert invitationlink;
        for(SurveyInvitation s : invitationlink) {
            SurveyInvid.add(s.id); 
        }
        List<SurveyInvitation> urllist= [select id,name ,Patient_Case__c,InvitationLink,ParticipantId from surveyInvitation where Id In :SurveyInvid];
        for(SurveyInvitation sinv : urllist) {
            SurveyInvitationids.put(sinv.Patient_Case__c,sinv.Id);
            surveyInvitationlink.put(sinv.Patient_Case__c,sinv.InvitationLink);
            system.debug(sinv.invitationlink);
        } 
        system.debug('SurveyInvitationids----'+ SurveyInvitationids);
        for(Opportunity thisopp : oList) {
            SurveySubject subj = new SurveySubject();
            subj.Name = 'First Consultation';
            subj.ParentId =SurveyInvitationids.get(thisopp.id); // similary you can use survey response id to associate survey subject to a response record. 
            subj.SubjectId = thisopp.Id; 
            system.debug(subj); 
            surveysubjectlist.add(subj);
            system.debug('surveyInvitationlink----'+ surveyInvitationlink);
            if(accountemail.get(thisopp.Practitioner_Name__c)!=null){
                system.debug('inside second if');
                remail.add(accountemail.get(thisopp.Practitioner_Name__c));
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(remail);
                mail.setSubject('Your feedback is important. Help us to improve by taking this survey.');
                String body = 'Hi ' +NameMap.get(thisopp.Practitioner_Name__c)+ ','+'<br><br>'; body += 'Thank you for reaching out to ART Fertility Clinics.'+'<br><br>';
                body += 'At ART Fertility clinics we would like to spare no effort in bringing the best of patient care services.'+'<br><br>';
                body += 'We would be grateful if you could take a few moments of your valuable time to share your experience by <a href='+surveyInvitationlink.get(thisopp.Id)+'> Clicking Here </a> '+'<br><br>';
                body += 'Thank you'+'<br><br>';
                body += 'ART Fertility Team';
                System.debug(body +' '+ mail);
                mail.setHtmlBody(body);
                mails.add(mail); 
            } 
        } 
        insert surveysubjectlist;
        Messaging.sendEmail(mails); 
    } 
}