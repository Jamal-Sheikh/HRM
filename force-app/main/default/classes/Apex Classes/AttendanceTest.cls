@isTest
public class AttendanceTest {
  
 
  public static Employee__c getEmployee(){
    Employee__c emp  = [select id, name from Employee__c where Mobile__c = '09007860135' ];
    return emp;
  }
    
    
  @TestSetup
    public static void attendanceCheckin(){
      Employee__c testEmployee = new Employee__c();
      testEmployee.Name = 'Test Class created';
      testEmployee.Email__c = 'testclass@gmail.com';
      testEmployee.Mobile__c = '09007860135';
      testEmployee.Password__c = 'testEmployee@example.com';
    
     testEmployee.UserName__c = 'User101';
  
      insert testEmployee;
     Employee__c  EmpID =  getEmployee();
        RestRequest request = new  RestRequest();
        RestResponse response = new  RestResponse();
        Map<String, Object> data = new Map<String, Object>();
        data.put('Date_Time', '2023-11-28T10:20:43');
        data.put('Status', 'Checked In');
        data.put('EmployeeID', EmpID.id);
        request.requestURI = '/services/apexrest/api/Attendance';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JSON.serialize(data));
      RestContext.request = request;
      RestContext.response = response;
        AttendanceController.markAttendance();
     Attendance__c att = [select id, Employee_Name__c from Attendance__c where Employee_Name__c = :EmpID.id limit 1];
        String stringResponse = response.responseBody.toString();
         System.assertEquals(200, response.statusCode, 'code is not 200');
        System.assertNotEquals(null, att.Id, 'Attendance record should have an ID');
        Assert.isTrue(stringResponse.contains(att.id));
    }
    
    
    @isTest
    public static void attendanceCheckinAgain(){
    Employee__c  EmpID =  getEmployee();
      RestRequest Newrequest = new  RestRequest();
      RestResponse Newresponse = new  RestResponse();
      Map<String, Object> Newdata = new Map<String, Object>();
      Newdata.put('Date_Time', '2023-11-28T10:20:43');
      Newdata.put('Status', 'Checked In');
      Newdata.put('EmployeeID', EmpID.id);
      Newrequest.requestURI = '/services/apexrest/api/Attendance';
      Newrequest.httpMethod = 'POST';
      Newrequest.requestBody = Blob.valueof(JSON.serialize(Newdata));
      RestContext.request = Newrequest;
      RestContext.response = Newresponse;
      AttendanceController.markAttendance();
      Map<String, Object> NewResponseData = (Map<String, Object>) JSON.deserializeUntyped(Newresponse.responseBody.toString());
       String NewResponseMessage = String.valueof(NewResponseData.get('error_description'));
      Integer NewResponseCode =  Integer.valueof(NewResponseData.get('status'));
      System.assertEquals(400,NewResponseCode , 'return code is not 400');
      System.assertEquals(400, Newresponse.statusCode, 'return code is not 400');
      System.assertEquals('Already checked in for Today', NewResponseMessage);
    }
    
    
    @isTest
    public static void attendanceCheckOut(){
       
      Employee__c  EmpID =  getEmployee();
         /*
        RestRequest request = new  RestRequest();
        RestResponse response = new  RestResponse();
        Map<String, Object> data = new Map<String, Object>();
        data.put('Date_Time', '2024-11-28T22:20:43');
        data.put('Status', 'Checked Out');
        data.put('EmployeeID', EmpID.id);
        request.requestURI = '/services/apexrest/api/Attendance';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JSON.serialize(data));
        RestContext.request = request;
        RestContext.response = response;
        AttendanceController.markAttendance();
        Attendance__c att = [select id, Employee_Name__c from Attendance__c where Employee_Name__c = :EmpID.id limit 1];
        String stringResponse = response.responseBody.toString();
      //  System.assertEquals(200, response.statusCode, 'code is not 200');
        System.assertNotEquals(null, att.id, 'Attendance record should have an ID');
        Assert.isTrue(stringResponse.contains(att.id));
 */
  
 
  //assert already checked out
          RestRequest Newrequest = new  RestRequest();
          RestResponse Newresponse = new  RestResponse();
          Map<String, Object> Newdata = new Map<String, Object>();
            Newdata.put('Date_Time', '2024-11-28T22:20:43');
            Newdata.put('Status', 'Checked Out');
            Newdata.put('EmployeeID', EmpID);
            Newrequest.requestURI = '/services/apexrest/api/Attendance';
            Newrequest.httpMethod = 'POST';
            Newrequest.requestBody = Blob.valueof(JSON.serialize(Newdata));
          RestContext.request = Newrequest;
          RestContext.response = Newresponse;
          AttendanceController.markAttendance();
          Map<String, Object> NewResponseBodyMap  = (Map<String, Object>) JSON.deserializeUntyped(Newresponse.responseBody.toString());
          String message = 'Already checked Out for Today';
          System.assertEquals(400, Newresponse.statusCode, 'code is not 400');
          System.assertEquals(message, NewResponseBodyMap.get('error_description'), 'attendance already checkout');
 
        
        
        
     //get  records valid Employee id
 
     RestRequest Getrequest = new  RestRequest();
     RestResponse Getresponse = new  RestResponse();
     Map<String, Object> Getdata = new Map<String, Object>();
      Getdata.put('EmployeeID', EmpID.id);
      Getdata.put('fromDate', '2022-06-20');
      Getdata.put('toDate', '2024-11-29');
      Getrequest.requestURI = '/services/apexrest/api/GetAttendanceByDate';
      Getrequest.httpMethod = 'GET';
      Getrequest.requestBody = Blob.valueof(JSON.serialize(Getdata));
     RestContext.request = Getrequest;
     RestContext.response = Getresponse;
     AttendanceGetByDateController.getAttendanceByDateRange();
    List<object> GetResponseBodyMap  = (List<object>) JSON.deserializeUntyped(Getresponse.responseBody.toString());
     system.debug(GetResponseBodyMap);
    System.assertEquals(200, Getresponse.statusCode, 'code is not 200');
     System.assertNotEquals(null, GetResponseBodyMap, 'At least one record should be returned');
   
        
        
        
   List<Attendance__c> attsss = [Select id, check_in__c,check_out__c,status__c from attendance__c];
        system.debug('all attendance records in test'+attsss);
     RestRequest GetrequestNullDates = new  RestRequest();
     RestResponse GetresponseGetNullDates = new  RestResponse();
     Map<String, Object> GetdataNullDates = new Map<String, Object>();
     GetdataNullDates.put('EmployeeID', EmpID.id);
     GetdataNullDates.put('fromDate', '');
      GetdataNullDates.put('toDate', '');
      GetrequestNullDates.requestURI = '/services/apexrest/api/GetAttendanceByDate';
      GetrequestNullDates.httpMethod = 'GET';
      //  String strrequest = '{"toDate":"","fromDate":"","EmployeeID":"'+EmpID.id+'"}';
      GetrequestNullDates.requestBody = Blob.valueof(JSON.serialize(GetdataNullDates));
        system.debug('emptydatebody: '+JSON.serialize(GetdataNullDates));
     RestContext.request = GetrequestNullDates;
     RestContext.response = GetresponseGetNullDates;
     AttendanceGetByDateController.getAttendanceByDateRange();
        system.debug('line149'+GetresponseGetNullDates.responseBody.toString());
 //   List<object> GetResponseBodyMapNullDates  = (List<object>) JSON.deserializeUntyped(GetresponseGetNullDates.responseBody.toString());
Map<String, Object> GetResponseBodyMapNullDates  = (Map<String, Object>) JSON.deserializeUntyped(GetresponseGetNullDates.responseBody.toString());
    system.debug('dec29'+GetResponseBodyMap);
    System.assertEquals(400, GetresponseGetNullDates.statusCode, 'code is not 400');
     System.assertNotEquals(null, GetResponseBodyMapNullDates, 'At least one record should be returned');
    // Assert.isTrue(stringResponse.contains(att.id));
   
        

    }
   
    @isTest
    public static void getAttendances(){
      //get  records invalid Employee id
         // Employee__c  EmpID =  getEmployee();
        RestRequest Getrequest = new  RestRequest();
        RestResponse Getresponse = new  RestResponse();
        Map<String, Object> Getdata = new Map<String, Object>();
         Getdata.put('EmployeeID', 'ioio');
         Getdata.put('fromDate', '2022-06-20');
         Getdata.put('toDate', '2023-11-30');
         Getrequest.requestURI = '/services/apexrest/api/GetAttendanceByDate';
         Getrequest.httpMethod = 'GET';
         Getrequest.requestBody = Blob.valueof(JSON.serialize(Getdata));
        RestContext.request = Getrequest;
        RestContext.response = Getresponse;
        AttendanceGetByDateController.getAttendanceByDateRange();
        Map<String, Object> NewResponseBodyMap  = (Map<String, Object>) JSON.deserializeUntyped(Getresponse.responseBody.toString());
          String message = 'No Records Found';
          System.assertEquals(400, Getresponse.statusCode, 'code is not 400');
          System.assertEquals(message, NewResponseBodyMap.get('error_description'), 'invalid eerror emssaged');
          system.debug(message);
          system.debug(NewResponseBodyMap.get('error_description'));
    }
    
     @isTest
    public static void getAttendancesFromNull(){
      //get  records invalid Employee id
          Employee__c  EmpID =  getEmployee();
        RestRequest Getrequest = new  RestRequest();
        RestResponse Getresponse = new  RestResponse();
        Map<String, Object> Getdata = new Map<String, Object>();
         Getdata.put('EmployeeID', EmpID.id);
         Getdata.put('fromDate', '');
         Getdata.put('toDate', '2023-11-30');
         Getrequest.requestURI = '/services/apexrest/api/GetAttendanceByDate';
         Getrequest.httpMethod = 'GET';
         Getrequest.requestBody = Blob.valueof(JSON.serialize(Getdata));
        RestContext.request = Getrequest;
        RestContext.response = Getresponse;
        AttendanceGetByDateController.getAttendanceByDateRange();
        Map<String, Object> NewResponseBodyMap  = (Map<String, Object>) JSON.deserializeUntyped(Getresponse.responseBody.toString());
          String message = 'Please Select a Valid Starting Date';
          System.assertEquals(400, Getresponse.statusCode, 'code is not 400');
          System.assertEquals(message, NewResponseBodyMap.get('error_description'), 'invalid eerror emssaged');
          system.debug(message);
          system.debug(NewResponseBodyMap.get('error_description'));
    }
    
    @isTest
    public static void getAttendanceToNull(){

        Employee__c  EmpID =  getEmployee();
   
   List<Attendance__c> attsss = [Select id, check_in__c,check_out__c,status__c from attendance__c];
        system.debug('all attendance records in test'+attsss);
     RestRequest GetrequestNullDates = new  RestRequest();
     RestResponse GetresponseGetNullDates = new  RestResponse();
     Map<String, Object> GetdataNullDates = new Map<String, Object>();
     GetdataNullDates.put('EmployeeID', EmpID.id);
     GetdataNullDates.put('fromDate', '2023-09-01');
      GetdataNullDates.put('toDate', '');
      GetrequestNullDates.requestURI = '/services/apexrest/api/GetAttendanceByDate';
      GetrequestNullDates.httpMethod = 'GET';
      //  String strrequest = '{"toDate":"","fromDate":"","EmployeeID":"'+EmpID.id+'"}';
      GetrequestNullDates.requestBody = Blob.valueof(JSON.serialize(GetdataNullDates));
        system.debug('emptydatebody: '+JSON.serialize(GetdataNullDates));
     RestContext.request = GetrequestNullDates;
     RestContext.response = GetresponseGetNullDates;
     AttendanceGetByDateController.getAttendanceByDateRange();

    }
    
}