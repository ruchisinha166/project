@isTest
public class markAttendanceController_Test {
    @isTest
    public static void method1(){
        Time checkTime=Time.newInstance(12, 20, 00,00);
        Datetime NewDate= Datetime.newInstance(System.today(), checkTime);
        Attendance__c attendanceObj= new Attendance__c();
        attendanceObj.Status__c='Absent';
        attendanceObj.User__c=UserInfo.getUserId();
        attendanceObj.Check_In_Time__c= NewDate;
        attendanceObj.Date__c= system.today();
        insert attendanceObj;
        
        test.startTest();
        markAttendanceController.markAttendanceMethod();
        test.stopTest();
    }
}