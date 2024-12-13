public with sharing class AttendanceMarkWrapper {
    public  String EmployeeID;
    public  String Status;
    public  String StringDateTime;
    public  String TimeString;
    public  String DateString;
    public  DateTime Date_Time;
     public  AttendanceMarkWrapper(RestRequest req) {
    Map<String, Object> RequestData = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
              EmployeeID = String.valueof(RequestData.get('EmployeeID'));
              Status = String.valueof(RequestData.get('Status'));
              StringDateTime =   String.valueof(RequestData.get('Date_Time'));
              TimeString= StringDateTime.substring(StringDateTime.lastIndexOf('T')+1);
              DateString = StringDateTime.left(StringDateTime.length()-9);
              Date_Time =  DateTime.valueof(DateString+' '+TimeString+'.000Z');
     }
}