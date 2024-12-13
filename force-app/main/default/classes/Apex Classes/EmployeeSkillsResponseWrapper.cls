public with sharing class EmployeeSkillsResponseWrapper {



    public String statusCode;
    public List <Employee_Skills__c> skillsList = new List <Employee_Skills__c>();
    public String message;




    public EmployeeSkillsResponseWrapper() {

    }
}