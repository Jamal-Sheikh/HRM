public with sharing class AttendanceGetWrapper {
    public String EmpID;
    public String StringFrom;
    public DateTime DateFrom;
    public DateTime TempDateFrom;
    public String StringTo;
    public  DateTime DateTo;
    public DateTime TempDateTo;
 
 
 		//parses the request body of getAttendanceByDateRange() of AttendanceGetByDateController
     public AttendanceGetWrapper(RestRequest req) {
       
                  
         Map<String, Object> RequestData = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());        
         EmpID = String.valueof(RequestData.get('EmployeeID'));
         StringFrom =   String.valueof(RequestData.get('fromDate'));
         StringTo =   String.valueof(RequestData.get('toDate'));
   
       
        
             
          if((StringFrom=='' )&& (StringTo=='')){
     
          DateFrom = null;
           DateTo = null;
             
         }
         else if(StringFrom==''&& StringTo!=''){
             
			 DateFrom = null;
              DateTo =  Date.valueof(StringTo);
         }
         else if(StringFrom!=''&& StringTo==''){
          
			 DateFrom =  Date.valueof(StringFrom); 
              DateTo =  null;
         }
         else{
    	
            DateFrom =  Date.valueof(StringFrom); 
              DateFrom = DateFrom-1;
         DateTo =  Date.valueof(StringTo);   
             DateTo =DateTo+1;
             
         } 
     
        
         
        
 
         
    
    
        
   
 
     }
}