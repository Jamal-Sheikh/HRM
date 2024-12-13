public with sharing class LeaveQuotaSelector {
    public LeaveQuotaSelector() {

    }


    // public static Leave_Quota__c leaveQuotaReturn(String employeeId, String year){

    // Integer YearInt =Integer.valueOf(year);   
    // Leave_Quota__c employeeLeaveQuota; 


    // try{
    //     employeeLeaveQuota =  [SELECT Id, Name, Annual_Leaves__c, Work_From_Home_s__c, Sick_Leaves__c  FROM Leave_Quota__c WHERE Employee_Name__c =: employeeId AND Year__c=: YearInt];
   
    //  }


    // catch(QueryException qe) {
    //     System.debug('The following exception has occurred:'  + qe.getMessage());

     
    // }

    // return employeeLeaveQuota;}


}