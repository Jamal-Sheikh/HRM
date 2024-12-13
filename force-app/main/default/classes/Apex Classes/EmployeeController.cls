@RestResource(urlMapping='/api/Employee/*')
global with sharing class EmployeeController {
    @HttpGet
    //This method returns detail of specific employee through employeeId 
    global static void employeeDetailsGet(){
      RestRequest request = RestContext.request;
      RestResponse response = RestContext.response;
      String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/') +1);
        list<Employee__c> employeeDetails = EmployeeSelector.getEmployee(employeeId);
        if(! employeeDetails.isEmpty( )){
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            String employeeJson = JSON.serialize(employeeDetails.get(0));
            response.responseBody = Blob.valueOf(employeeJson);
        }
        else{
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            String employeeJson = JSON.serialize('Invalid employeeId');
            response.responseBody = Blob.valueOf(employeeJson);
        }
     }
    }