@istest
public class CreateDailyAttendance_Test {
    public static testMethod void testschedule() {
        Test.StartTest();
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User u = new User();
        u.Grade__c = 'E1';
        u.FirstName = 'test';
        u.LastName = 'test';
        u.Alias = 'ttest';
        u.Email = 'test@gmail.com';
        u.Username = 'test@gmail.com.stylam202204';
        u.CommunityNickname = 'test';
        u.Related_To_Business__c = 'Domestic';
        u.Dealing_in_Categories__c = 'Cubicles';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = pf.Id;
        u.IsActive = true;
        INSERT u;
        
        Userwise_Working_Day__c uwd =New Userwise_Working_Day__c();
        uwd.Name = 'Test';
        uwd.User__c = u.id;
        integer Year = system.today().year();
        uwd.Year__c = string.valueOf(Year);
        insert uwd;
        
        main(u.id);
        
        CreateDailyAttendance sh1 = new CreateDailyAttendance();
        Database.executeBatch(sh1);
        Test.stopTest(); 
    }
    public static testMethod void testMethod_01() {
        Test.StartTest();
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User u = new User();
        u.Grade__c = 'E1';
        u.FirstName = 'test';
        u.LastName = 'test';
        u.Alias = 'ttest';
        u.Email = 'test@gmail.com';
        u.Username = 'test@gmail.com.stylam202204';
        u.CommunityNickname = 'test';
        u.Related_To_Business__c = 'Domestic';
        u.Dealing_in_Categories__c = 'Cubicles';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = pf.Id;
        u.IsActive = true;
        INSERT u;
        
        Userwise_Working_Day__c uwd =New Userwise_Working_Day__c();
        uwd.Name = 'Test';
        uwd.User__c = u.id;
        integer Year = system.today().year();
        uwd.Year__c = string.valueOf(Year);
        insert uwd;
        
        Holiday_Calander__c holidayCalender= New Holiday_Calander__c();
        holidayCalender.Name = 'Test';
        holidayCalender.Holiday_Dates__c = '4; 16; 23';
        holidayCalender.Holiday_Month__c = '11';
        holidayCalender.Zone__c ='South; West';
        insert holidayCalender;
        
        main(u.id);
        
        CreateDailyAttendance sh1 = new CreateDailyAttendance();
        Database.executeBatch(sh1);
        Test.stopTest(); 
    }
    public static testMethod void testMethod_02() {
        Test.StartTest();
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User u = new User();
        u.Grade__c = 'E1';
        u.FirstName = 'test';
        u.LastName = 'test';
        u.Alias = 'ttest';
        u.Email = 'test@gmail.com';
        u.Username = 'test@gmail.com.stylam202204';
        u.CommunityNickname = 'test';
        u.Related_To_Business__c = 'Domestic';
        u.Dealing_in_Categories__c = 'Cubicles';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = pf.Id;
        u.Zone__c ='South';
        u.IsActive = true;
        INSERT u;
        
        Userwise_Working_Day__c uwd =New Userwise_Working_Day__c();
        uwd.Name = 'Test';
        uwd.User__c = u.id;
        integer Year = system.today().year();
        integer Month = system.today().Month();
        integer day = system.today().day();
        system.debug('Year----'+ Year);
        system.debug('day----'+ day);
        uwd.Year__c = string.valueOf(Year);
        insert uwd;
        
        Holiday_Calander__c holidayCalender= New Holiday_Calander__c();
        holidayCalender.Name = 'Test';
        holidayCalender.Holiday_Dates__c = string.valueOf(day);
        holidayCalender.Holiday_Month__c = string.valueOf(Month);
        holidayCalender.Zone__c ='South; West';
        holidayCalender.Year__c =string.valueOf(Year);
        insert holidayCalender;
        
        main(u.id);
        
        CreateDailyAttendance sh1 = new CreateDailyAttendance();
        Database.executeBatch(sh1);
        Test.stopTest(); 
    }
    
    public static testMethod void testMethod_03() {
        Test.StartTest();
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User u = new User();
        u.Grade__c = 'E1';
        u.FirstName = 'test';
        u.LastName = 'test';
        u.Alias = 'ttest';
        u.Email = 'test@gmail.com';
        u.Username = 'test@gmail.com.stylam202204';
        u.CommunityNickname = 'test';
        u.Related_To_Business__c = 'Domestic';
        u.Dealing_in_Categories__c = 'Cubicles';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = pf.Id;
        u.Zone__c ='South';
        u.IsActive = true;
        INSERT u;
        
        Userwise_Working_Day__c uwd =New Userwise_Working_Day__c();
        uwd.Name = 'Test';
        uwd.User__c = u.id;
        integer Year = system.today().year();
        integer Month = system.today().Month();
        integer day = system.today().day();
        system.debug('Year----'+ Year);
        system.debug('day----'+ day);
        uwd.Year__c = string.valueOf(Year);
        insert uwd;
        
        Holiday_Calander__c holidayCalender= New Holiday_Calander__c();
        holidayCalender.Name = 'Test';
        holidayCalender.Holiday_Dates__c = string.valueOf(day);
        holidayCalender.Holiday_Month__c = string.valueOf(Month);
        holidayCalender.Zone__c ='West';
        holidayCalender.Year__c =string.valueOf(Year);
        insert holidayCalender;
        
        main(u.id);
        
        CreateDailyAttendance sh1 = new CreateDailyAttendance();
        Database.executeBatch(sh1);
        Test.stopTest(); 
    }

    
    @future
    public static void main(String userId){
        PermissionSet newPermission = [SELECT Id FROM PermissionSet WHERE Name = 'Mark_Attendance'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = userId;
        psa.PermissionSetId = newPermission.Id;
        INSERT psa;
    }
}