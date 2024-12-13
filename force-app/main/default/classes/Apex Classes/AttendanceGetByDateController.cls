@Restresource(urlMapping='/api/GetAttendanceByDate')
global with sharing class AttendanceGetByDateController {
    //get attendance between two given dates
    @HttpPost
    global static void getAttendanceByDateRange(){
        RestRequest req = RestContext.request;    
      
        AttendanceGetWrapper  wrapperList = new AttendanceGetWrapper(req);
        if(wrapperList.DateFrom==null && wrapperList.DateTo==null){
            List<Attendance__c> AttList =     AttendanceSelector.getAttendaceThisMonth(wrapperList.EmpID);
            
           sendListToResponse(Attlist);
        }
        else if(wrapperList.DateFrom==null && wrapperList.DateTo!=null){
       
                  AttendanceController.response('400','Please Select a Valid Starting Date'); 
                
           
        }
        
        else if(wrapperList.DateFrom!=null && wrapperList.DateTo==null){
            List<Attendance__c> AttList =     AttendanceSelector.getAttendaceFromDateOnly(wrapperList.EmpID,wrapperList.DateFrom );
            
          sendListToResponse(Attlist);
        }
        else{

             List<Attendance__c> AttList =     AttendanceSelector.getAttendaceBetweenDates(wrapperList.EmpID, wrapperList.DateFrom, wrapperList.DateTo);
          sendListToResponse(Attlist);
        }
           
       
        
    }
    
    //invokes the response() with sucess or error message
    public static void sendListToResponse(List<Attendance__c> AttList){
          RestResponse res;
         if(AttList.size()==0){
                res =  AttendanceController.response('400','No Records Found'); 
                
            }
            else{                                
                res = AttendanceController.response(200, AttList);
            }
        
   }
}