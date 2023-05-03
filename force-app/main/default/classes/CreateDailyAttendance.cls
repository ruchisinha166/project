public class CreateDailyAttendance implements Database.Batchable<sObject> , Schedulable {
    
    public void execute(SchedulableContext ctx) {
        
        Id batchId = Database.executeBatch(new CreateDailyAttendance());
    }
    
    public List<User> start(Database.BatchableContext bc) {
        
        Set<Id> permissionSetIds = new Set<Id>();
        
        for (SetupEntityAccess access : [SELECT ParentId FROM SetupEntityAccess WHERE SetupEntityId IN 
                                         (SELECT Id FROM CustomPermission WHERE DeveloperName = 'Mark_Attendance')]) {
                                             permissionSetIds.add(access.ParentId);
                                         }
        
        return [SELECT Username,Zone__c, email FROM User WHERE isActive = True AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId IN :permissionSetIds)];
    }
    
    public void execute(Database.BatchableContext bc, List<User> records){
        Date currentDate = system.today();
        Set<Id> userIds = new Set<Id>();
        List<Attendance__c> todayAttendanceList = [Select Id, Name, Date__c,User__c FROM Attendance__c WHERE Date__c =: currentDate];
        List<Attendance__c> attendanceLst = new List<Attendance__c>();
        List<Userwise_Working_Day__c> uwDays = [Select Id,Name,User__c,Year__c FROM Userwise_Working_Day__c WHERE Year__c =: string.valueOf(currentDate.year())];
        system.debug('uwDays'+uwDays);
        
        Map<Id,Userwise_Working_Day__c> uwMap = new Map<Id,Userwise_Working_Day__c>();
        for(Userwise_Working_Day__c uw : uwDays){
            uwMap.put(uw.User__c,uw);
        }
        system.debug('uwMap:- '+uwMap);
        for(Attendance__c att : todayAttendanceList){
            userIds.add(att.User__c);
        }
        List<Holiday_Calander__c> holidayList = [Select Id,Name,Holiday_Month__c,Zone__c,Holiday_Dates__c
                                                 FROM Holiday_Calander__c
                                                 WHERE Holiday_Month__c =: String.valueOf(system.today().month())];
        Map<Date,List<String>> hcMap = new Map<Date,List<String>>();
        for(Holiday_Calander__c hc : holidayList){
            List<String> splitDate = hc.Holiday_Dates__c.split(';');
            List<String> zoneList = hc.Zone__c.split(';');
            for(String d : splitDate){
                Date todayDate = date.newinstance(system.today().year(), Integer.valueOf(hc.Holiday_Month__c), Integer.valueOf(d));
                system.debug('todayDate----'+todayDate);
                hcMap.put(todayDate,zoneList);
            }
        }
        DateTime myDateTime = system.now();
        String dayOfWeek = myDateTime.format('E');
        List<String> strList = (System.Label.Week_Off).split(',');
        
        
        for(User user: records){
            system.debug('user----'+user);
            if(!userIds.contains(user.Id)){
                if(uwMap.get(user.Id) != Null){
                    if(!strList.contains(dayOfWeek)){
                        if(hcMap.get(system.today()) != Null){
                            if(hcMap.get(system.today()).contains(user.Zone__c )){                        
                                Attendance__c attendance = new Attendance__c();
                                Time cutOffTime = Time.newInstance(09, 45, 00, 00);
                                attendance.User__c = user.Id;
                                attendance.Date__c = Date.today();
                                attendance.Status__c = 'Holiday';
                                attendance.Email__c = user.email;
                                attendance.Userwise_Working_Day__c = uwMap.get(user.Id).Id;
                                attendance.Cut_off_Time__c = cutOffTime;
                                attendanceLst.add(attendance);
                            }
                            else{
                                Attendance__c attendance = new Attendance__c();
                                Time cutOffTime = Time.newInstance(09, 45, 00, 00);
                                attendance.User__c = user.Id;
                                attendance.Date__c = Date.today();
                                attendance.Status__c = 'Absent';
                                attendance.Email__c = user.email;
                                attendance.Userwise_Working_Day__c = uwMap.get(user.Id).Id;
                                attendance.Cut_off_Time__c = cutOffTime;
                                attendanceLst.add(attendance);
                            }
                        }
                        else{
                            Attendance__c attendance = new Attendance__c();
                            Time cutOffTime = Time.newInstance(09, 45, 00, 00);
                            attendance.User__c = user.Id;
                            attendance.Date__c = Date.today();
                            attendance.Status__c = 'Absent';
                            attendance.Email__c = user.email;
                            attendance.Userwise_Working_Day__c = uwMap.get(user.Id).Id;
                            attendance.Cut_off_Time__c = cutOffTime;
                            attendanceLst.add(attendance);
                        }
                    }
                    else{
                        Attendance__c attendance = new Attendance__c();
                            Time cutOffTime = Time.newInstance(09, 45, 00, 00);
                            attendance.User__c = user.Id;
                            attendance.Date__c = Date.today();
                            attendance.Status__c = 'Week-Off';
                            attendance.Email__c = user.email;
                            attendance.Userwise_Working_Day__c = uwMap.get(user.Id).Id;
                            attendance.Cut_off_Time__c = cutOffTime;
                            attendanceLst.add(attendance);
                    }
                }
            }
        }
        if(!attendanceLst.isEmpty()){insert attendanceLst;}
        
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}