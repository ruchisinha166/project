public with sharing class HandleAttandenceController {
    @AuraEnabled(Cacheable = true)
    public static String checkCurrentStatus(){
        Date currentDate = system.today();
        String status;
        List<String> dayList = new List<String>();
        List<String> zoneList = new List<String>();
        Boolean holidayCheck = false;
        User currentUser = [Select Id,FirstName,LastName,Zone__c FROM User WHERE Id =: UserInfo.getUserId() AND isActive = true];
        List<Holiday_Calander__c> holidayList = [Select Id,Name,Holiday_Dates__c,Holiday_Month__c,Zone__c FROM Holiday_Calander__c WHERE (Holiday_Month__c =: String.valueOf(currentDate.month()))];                                          
        if(!holidayList.isEmpty()){
            for(Holiday_Calander__c hc : holidayList){
                dayList = hc.Holiday_Dates__c.split(';');
                zoneList = hc.Zone__c.split(';');
                if(dayList.contains(String.valueOf(currentDate.day())) && zoneList.contains(String.valueOf(hc.Zone__c))){
                    holidayCheck = true;
                    status = 'None';
                }
            }
        }
        if(holidayList.isEmpty() || holidayCheck == false){
            Attendance__c attendanceRec = [SELECT Id, Name, Date__c, User__c,Cut_off_Time__c,Status__c,Check_In_Time__c,Check_Out_Time__c FROM Attendance__c WHERE Date__c =: currentDate AND User__c =: UserInfo.getUserId()];
            Boolean checkout = false;
            Time halfDayCheckTime = Time.newInstance(13, 30, 0, 00);
            if(attendanceRec.Cut_off_Time__c < system.now().time()){
                checkout = true;
            }
            system.debug('checkout'+checkout);

            if(attendanceRec.Status__c == 'Leave - Approved (First Half)'){
                if(system.now().time() < halfDayCheckTime){
                    status = 'None';
                }
                else if(system.now().time() > halfDayCheckTime){
                    status = 'halfDay';
                }
            }
            else if(attendanceRec.Status__c == 'Leave - Approved (Second Half)'){
                if(system.now().time() < halfDayCheckTime){
                    status = 'halfDay';
                }
                else if(system.now().time() > halfDayCheckTime){
                    status = 'None';
                }
            }
            else if((attendanceRec.Status__c == 'Present' || attendanceRec.Status__c == 'Leave - Approved (First Half)' || attendanceRec.Status__c == 'Leave - Approved (Second Half)') && attendanceRec.Check_In_Time__c != Null && attendanceRec.Check_Out_Time__c == NULL){
                status = 'punchout';
            }
            else if(attendanceRec.Status__c == 'Absent' && attendanceRec.Check_In_Time__c == Null && attendanceRec.Check_Out_Time__c == NULL && checkout == True){
                status = 'halfDay';
            }
            else if(attendanceRec.Status__c == 'Absent' && attendanceRec.Check_In_Time__c == Null && attendanceRec.Check_Out_Time__c == NULL && checkout == False){
                status = 'both';
            }
            system.debug('status$$$$$$$'+status);	            
        }
        return status;
    }
    @AuraEnabled
    public static void doPunchIn() { 
        Date todayDate = system.today();
        Attendance__c attendanceRec = [SELECT Id,Name,Status__c,Check_In_Time__c,Cut_off_Time__c FROM Attendance__c WHERE Date__c =: todayDate AND Status__c = 'Absent' AND User__c =: UserInfo.getUserId()];
        if(attendanceRec != Null){
            attendanceRec.Status__c = 'Present';
            attendanceRec.Check_In_Time__c = system.now();
            update attendanceRec;
        }
    }
    @AuraEnabled
    public static void doPunchOut() { 
        Date todayDate = system.today();
        Attendance__c attendanceRec = [SELECT Id,Name,Status__c,Check_Out_Time__c FROM Attendance__c WHERE Date__c =: todayDate AND (Status__c = 'Present' OR Status__c = 'Half Day') AND User__c	=: UserInfo.getUserId()];
        if(attendanceRec != Null){
            //attendanceRec.Status__c = 'Present';
            attendanceRec.Check_Out_Time__c = system.now();
            update attendanceRec;
        }
    }
    @AuraEnabled
    public static void halfDay() { 
        Date todayDate = system.today();
        Attendance__c attendanceRec = [SELECT Id,Name,Status__c,Check_In_Time__c FROM Attendance__c WHERE Date__c =: todayDate  AND Status__c = 'Absent' AND User__c =: UserInfo.getUserId()];
        if(attendanceRec != Null){
            //attendanceRec.Status__c = 'Half Day';
            attendanceRec.Check_In_Time__c = system.now();
            update attendanceRec;
        }
    }
}