@isTest
public class HandleAttandenceController_Test {
    @testSetup
    static void testSetup(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User u = new User();
        u.Grade__c = 'E1';
        u.FirstName = 'test';
        u.LastName = 'test';
        u.Alias = 'ttest';
        u.Email = 'test@gmail.com';
        u.Username = 'test@gmail.com.stylam2022';
        u.CommunityNickname = 'test1';
        //u.Related_To_Business__c = 'Domestic';
        //u.Dealing_in_Categories__c = 'Cubicles';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = pf.Id;
        u.Grade__c = 'M1';
        INSERT u;
        Holiday_Calander__c holiday = new Holiday_Calander__c ();
        holiday.Holiday_Dates__c = '1';
        holiday.Holiday_Month__c = String.valueOF(System.today().month());
        holiday.Zone__c = 'East';
        insert holiday;
        Time checkTime=Time.newInstance(12, 20, 00,00);
        Datetime NewDate= Datetime.newInstance(System.today(), checkTime);
        Attendance__c attendanceObj= new Attendance__c();
        attendanceObj.Status__c='Absent';
        attendanceObj.User__c=userinfo.getUserId();
        attendanceObj.Check_In_Time__c= NewDate;
        attendanceObj.Date__c= system.today();
        insert attendanceObj;
    }
    static testMethod void test1(){
        Attendance__c att = [Select id,Status__c,User__c,Check_In_Time__c,Date__c from Attendance__c];
        att.Status__c = 'Half Day';
        update att;
    	HandleAttandenceController.checkCurrentStatus();    
    }
    static testMethod void test2(){
        Attendance__c att = [Select id,Status__c,User__c,Check_In_Time__c,Date__c from Attendance__c];
        att.Status__c = 'Absent';
        att.Check_In_Time__c = null;
        att.Cut_off_Time__c = Datetime.now().addDays(-1).time();
        update att;
    	HandleAttandenceController.checkCurrentStatus();    
    }
    static testMethod void test3(){
        Attendance__c att = [Select id,Status__c,User__c,Check_In_Time__c,Date__c from Attendance__c];
        att.Status__c = 'Absent';
        att.Check_In_Time__c = null;
        update att;
    	HandleAttandenceController.checkCurrentStatus();
        HandleAttandenceController.doPunchIn();
        //HandleAttandenceController.halfDay();
    }
    static testMethod void test4(){
    	Attendance__c att = [Select id,Status__c,User__c,Check_In_Time__c,Date__c from Attendance__c];
        att.Status__c = 'Present';
        att.Check_In_Time__c = null;
        update att;
        HandleAttandenceController.doPunchOut();
    }

}