@Restresource(urlMapping='/api/Attendance/*')
global with sharing class AttendanceController {
   //marks Employee attendace, 'Checked In' status creates the record and 'Checked Out' status update the record
    @HttpPost
    global static void markAttendance() {
        RestRequest req = RestContext.request;
        RestResponse res =  RestContext.response;
        AttendanceMarkWrapper  wrapperList = new AttendanceMarkWrapper(req);
            if(wrapperList.Status=='Checked In'){
                RestContext.response =   checkIn(wrapperList.Status,wrapperList.EmployeeID, wrapperList.Date_Time);
            }
            if(wrapperList.Status=='Checked Out'){
                RestContext.response =     checkOut(wrapperList.Status,wrapperList.EmployeeID, wrapperList.Date_Time);
            }
    }
          //checkin method
          public static RestResponse checkIn(String Status, String  EmployeeID, DateTime Date_TIme){
            RestResponse res;
            List<Attendance__c> AttList = new List<Attendance__c>();
            Attendance__c Att = new Attendance__c();
            List<Attendance__c> ImustBeEmpty =    AttendanceSelector.getCheckOut(EmployeeID, Date_Time);
              
                   //error response if checkin already exists
                    if(ImustBeEmpty.size() >0){
                        res =    response('400','Already checked in for Today' );
                    }else{
                        Att.Status__c= Status;
                        Att.Check_In__c=Date_Time;
                        Att.Employee_Name__c =  EmployeeID;
                        AttList.add(Att);
                        insert AttList;
                        res =  response(200,AttList );
                    }
                    return res;
        }
        //checkout method
        public static RestResponse checkOut(String Status, String  EmployeeID, DateTime Date_TIme){
            RestResponse res;
            List<Attendance__c> CheckedInAttendance =    AttendanceSelector.getCheckOut(EmployeeID, Date_Time);
            //error response if checkin attendance is not found
            if(CheckedInAttendance.size() ==0){
                res =  response('400','Already checked Out for Today' );
            }else{
                CheckedInAttendance[0].Status__c =Status;
                CheckedInAttendance[0].Check_Out__c = Date_Time;
                update CheckedInAttendance;
                res =    response(200, CheckedInAttendance );
            }
            return res;
        }
         //method for error response
    public static RestResponse response(String code, String message){
        RestResponse res = RestContext.response;
        Map<String, String> error = new  Map<String, String>();
        error.put('error_description',message);
        error.put('status',code );
        res.statusCode =400;
        res.addheader('Content-Type', 'application/json');
        res.responseBody = Blob.valueof(JSON.serialize(error));
        return res;
    }
    //returns response for a successfull checkout/get record
    public static RestResponse response(Integer code, List<Attendance__c> attendanceRecord){
        RestResponse res = RestContext.response;
        res.statusCode =code;
        res.addheader('Content-Type', 'application/json');
        res.responseBody = Blob.valueof(JSON.serialize(attendanceRecord));
        return res;
    }
 
}