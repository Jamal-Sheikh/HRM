public class EmployeeSelector {

    //daniyal
    
    Public static list<Employee__c> getEmployee(String email, String password )
    {
        list<Employee__c> Employee = [SELECT id, Name, Email__c, Profile_Image__c, Password__c FROM Employee__c WHERE Email__c = :email AND Password__c = :password];
        return Employee;
    }
    public static list<Employee__c> verifyUser(String email)
    {
        list<Employee__c> Employee = new list<Employee__c>();
        Employee = [SELECT Id, Email__c FROM Employee__c WHERE Email__c = :email ];
        return Employee;
    }
    
        public static list<Employee__c> verifyUserId(String employeeId)
    {
        list<Employee__c> Employee = new list<Employee__c>();
        Employee = [SELECT Id, Email__c FROM Employee__c WHERE id = :employeeId ];
        return Employee;
    }
    
    public static list<Employee__c> updateUserPassword(String OTPkey )
    {
        list<Employee__c> Employee = [select id,Password__c, Profile_Image__c, name from employee__c where id = :OTPkey ];
        return Employee;
    }












    //farhan
    public static list<Employee__c> getEmployee(String employeeId){
        list<Employee__c> employeeDetails = [Select Id, Name, Email__c, Mobile__c, Password__c, UserName__c, Designation__c, Profile_Image__c From Employee__c Where Id =: employeeId];
        return employeeDetails;
     }



}