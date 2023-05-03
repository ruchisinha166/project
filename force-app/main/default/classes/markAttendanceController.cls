public class markAttendanceController {
    @auraEnabled(Cacheable = 'true')
    public static boolean markAttendanceMethod(){
        boolean isCheck = false;
        system.debug('Current Time-- '+ system.now());
        Time checkTime = Time.newInstance(15,45,00,00);
        system.debug('(system.now()).Time()-- '+ (system.now()).Time());
        system.debug('checkTime-- '+ checkTime);
        if((system.now()).Time() <= checkTime){
            system.debug('true-- ');
            isCheck = true;
        }
        system.debug('isCheck-- '+ isCheck);
        return isCheck;        
    }
}