public with sharing class LeaveSelector {
    
    
    
    public LeaveSelector() {
    }


    public static List <Leave__c> getPendingAndApprovedLeaves(String employeeId){

      
      List <Leave__c> pendingLeaves = new List<Leave__c>();

      date lastThirtyDays= date.TODAY() - 30;

      try {

        pendingLeaves = [SELECT Name, Status__c, Leave_From__c, Leave_To__c, Type__c FROM Leave__c WHERE (Status__c= 'Submitted for Approval' OR Status__c= 'Approved' OR Status__c= 'Pending' ) AND Employee_Name__c=:employeeId AND  Leave_From__c >=: lastThirtyDays ];
        
      }

      catch(exception e) {
        System.debug('The error occured is '+e);
      }

      return pendingLeaves;

    }


    public static List <Leave__c> getAppliedLeavesByDate (String employeeId, String startDate, String endDate ){

      Date fromDate = Date.valueOf(startDate);
      Date toDate = Date.valueOf(endDate);
      List <Leave__c> leavesByDate = new List<Leave__c>();

      try {

        leavesByDate = [SELECT Name from Leave__c WHERE Leave_From__c=:fromDate AND Leave_To__c=:toDate AND Status__c= 'Submitted for Approval' AND Employee_Name__c=:employeeId ];
        
      }

      catch(exception e) {
        System.debug('The error occured is '+e);
      }


      return leavesByDate;



    }


    public static List <Leave__c> deleteLeave (String Id){


      
      
      List <Leave__c> result = new List <Leave__c>();
      try{
      
        result = [SELECT Id FROM Leave__c WHERE Id= : Id AND Status__c= 'Submitted for Approval'  ];

      }

      catch (exception e){

      System.debug('The error occured is '+e);

      }

      return result;

    }



    public static List <Leave__c> getLeavesByDate (String employeeId, Date startDate, Date endDate, List<String> type , List<String> status ){

     
      List <Leave__c> approvedLeavesBydate = new List<Leave__c>();


      try {

      //String check ='SELECT COUNT() from Leave__c WHERE Leave_From__c>=:'+startDate+' AND Leave_From__c<='+Date.TODAY()+' AND Status__c= '+'Approved'+' AND Employee_Name__c=:'+employeeId+' AND Type__c=:'+ type +'';

      //System.debug(check);
      
      approvedLeavesBydate = [SELECT Name, Type__c, Leave_From__c, Leave_To__c, Leave_Nature__c from Leave__c WHERE Leave_From__c>=:startDate AND Leave_From__c<=:endDate AND Status__c IN : status AND Employee_Name__c=:employeeId AND Type__c IN : type ];
      
      
      System.debug('approvedleaves by date '+ approvedLeavesBydate);

        
      }

      catch(exception e) {
        System.debug('The error occured is '+e);
      }


      return approvedLeavesBydate;



    }




  public static Employee__c employeeDetailsGetter(String employeeId){

    Employee__c employeeDetails = new Employee__c();

    try{

       employeeDetails= [SELECT Designation__c, Email__c FROM  Employee__c  WHERE id =: employeeId  ];

      }

    catch(QueryException qe){

      System.debug( 'Employee does not exist  '+ qe);

      }

      return employeeDetails;

  }











}