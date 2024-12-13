public class AttendanceSelector {
    //gets the current attendance record to be checked out
    public static List<Attendance__c> getCheckOut(String EmpID, DateTime Date_Time){
        DateTime checkInDate =  Date.valueof(Date_Time);
       
        List<Attendance__c> att = new List<Attendance__c>();
         
        att = [Select id, Status__c, Employee_Name__r.Name, Check_In__c, Check_Out__c from Attendance__c where  (Employee_Name__c =:EmpID and Status__c='Checked In' and Check_In__c>=:  checkInDate)];
        
         return att;
    }
    //get attendances of an employee between two valid date values
    public static List<Attendance__c> getAttendaceBetweenDates(String  EmpID, DateTime DateFrom, DateTime DateTo){
        List<Attendance__c> AttList = new List<Attendance__c>();
        DateFrom = DateFrom.addHours(18);
   
        AttList = [Select id,Employee_Name__r.Name, Status__c, Check_In__c, Check_Out__c, Working_Hours__c from Attendance__c where Employee_Name__c=:EmpID And  Check_In__c>= :DateFrom  And  Check_In__c<= :DateTo  ]; 
                
        return AttList;
    }
    //get all the attendances of an employee of the current month
        public static List<Attendance__c> getAttendaceThisMonth(String  EmpID){
        List<Attendance__c> AttList = new List<Attendance__c>();
        
            Date startOfMonth = Date.today().toStartOfMonth();
			Date startOfNextMonth = startOfMonth.addMonths(1);
        AttList = [Select id,Employee_Name__r.Name, Status__c, Check_In__c, Check_Out__c, Working_Hours__c from Attendance__c where Employee_Name__c=:EmpID And  Check_In__c>= :startOfMonth  And  Check_In__c< :startOfNextMonth ]; 
          
        return AttList;
    }
    //get attendace from a specific date to today
       public static List<Attendance__c> getAttendaceFromDateOnly(String  EmpID,  DateTime DateFrom){
        List<Attendance__c> AttList = new List<Attendance__c>();
            DateFrom = DateFrom.addHours(18);
         Date todayDate = Date.today();
        AttList = [Select id,Employee_Name__r.Name, Status__c, Check_In__c, Check_Out__c, Working_Hours__c from Attendance__c where Employee_Name__c=:EmpID  And  Check_In__c>= :DateFrom   And  Check_In__c<= :todayDate]; 
       
        return AttList;
    }

}