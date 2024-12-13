@isTest
public with sharing class LeaveTest {


    public LeaveTest() {

    }


    @TestSetup
    public static void createTestEmployee(){

        Employee__c testEmployee = new Employee__c();
        testEmployee.Name = 'Test Class created employee';
        testEmployee.Email__c = 'testclass@gmail.com';
        testEmployee.Mobile__c = '090078601';
        testEmployee.Password__c = 'testEmployee@example.com';
        testEmployee.UserName__c = 'User101';
        testEmployee.Designation__c= 'Manager';
       
        insert testEmployee;


    }

    public static Employee__c getTestEmployee(){

        Employee__c testEmployee= [SELECT Id FROM Employee__c WHERE Mobile__c = '090078601'];
        return testEmployee;


    }

    

    @isTest
    static void testSickLeave() {
        
        Employee__c testEmployee = getTestEmployee();
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Leave_Quota__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"name": "Test intgertatin","type": "Sick","year": "2023","fromDate": "2023-09-27","toDate": "2023-09-28","description": "a005g00003EYoa4AAD","leaveNature": "Full Day","designation": "Architect" }');

        RestContext.request = req;
        RestContext.response = res;

        LeaveController.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        Assert.isTrue(res.responseBody.toString().contains('Request Successfully Submitted ! '), 'True It contains the correct response ');

    }

    
    @isTest
    static void testAnnualLeave() {
        
        Employee__c testEmployee = getTestEmployee();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Leave_Quota__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"name": "Test intgertatin","type": "Annual","year": "2024","fromDate": "2024-12-27","toDate": "2024-12-30","description": "a005g00003EYoa4AAD","leaveNature": "Full Day","designation": "Architect" }');

        RestContext.request = req;
        RestContext.response = res;

        LeaveController.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        Assert.isTrue(res.responseBody.toString().contains('Request Successfully Submitted ! '), 'True It contains the correct response ');


    }


    @isTest
    static void testWorkFromHomeLeave() {
        
        Employee__c testEmployee = getTestEmployee();
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Leave_Quota__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"name": "Test intgertatin","type": "Work from Home","year": "2024","fromDate": "2024-12-27","toDate": "2024-12-28","description": "a005g00003EYoa4AAD","leaveNature": "Full Day","designation": "Architect" }');

        RestContext.request = req;
        RestContext.response = res;

        LeaveController.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        //Assert.isTrue(res.responseBody.toString().contains('Request Successfully Submitted ! '), 'True It contains the correct response ');

        Assert.isTrue(res.responseBody.toString().contains('Request Successfully Submitted ! '), 'True It contains the correct response ');

    }



    @isTest
    static void testEmergencyLeave() {
        
        Employee__c testEmployee = getTestEmployee();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Leave_Quota__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"name": "Test intgertatin","type": "Emergency","year": "2023","fromDate": "2023-12-27","toDate": "2023-12-30","description": "a005g00003EYoa4AAD","leaveNature": "Full Day","designation": "Architect" }');

        RestContext.request = req;
        RestContext.response = res;

        LeaveController.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        Assert.isTrue(res.responseBody.toString().contains('Request Successfully Submitted ! '), 'True It contains the correct response ');


    }


    @isTest
    static void testInvalidLeave() {
        
        Employee__c testEmployee = getTestEmployee();
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Leave_Quota__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"name": "Test intgertatin","type": "Casual","year": "2023","fromDate": "2023-12-27","toDate": "2023-12-30","description": "a005g00003EYoa4AAD","leaveNature": "Full Day","designation": "Architect" }');

        RestContext.request = req;
        RestContext.response = res;

        LeaveController.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        Assert.isTrue(res.responseBody.toString().contains('Not a valid type of leave'), 'True It contains the correct response ');


    }




    @isTest
    static void testEmptyLeave() {
        
        Employee__c testEmployee = getTestEmployee();
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Leave_Quota__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;

        LeaveController.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        Assert.isTrue(res.responseBody.toString().contains('The request body is empty'), 'True if contains the correct response ');


    }



    @isTest
    static void testDeleteLeave() {

        Employee__c testEmployee = getTestEmployee();

        Leave__c testLeave = new Leave__c();
        testLeave.Name = 'Test Leave';
        testLeave.Type__c= 'Sick';
        testLeave.Description__c= 'des';
        testLeave.Leave_From__c= Date.TODAY();
        testLeave.Leave_To__c=Date.TODAY();
        testLeave.Status__c= 'Submitted for Approval';
        testLeave.Employee_Name__c=testEmployee.id;
        insert testLeave;

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
       
        
        request.requestURI = '/services/apexrest/api/Leave__c/'+ testLeave.Id; 
        request.httpMethod = 'DELETE';
       
        RestContext.request = request;
        RestContext.response = response;

        
        LeaveController.deleteLeave();

        
        System.assertEquals(200, response.statusCode, 'Expected a successful response code');
        Assert.isTrue( response.responseBody.toString().contains('Successfully'), 'Response message should be "Successfully deleted!"');

        List<Leave__c> deletedLeave = [SELECT Id FROM Leave__c WHERE Id = :testLeave.Id LIMIT 1];
        System.assert(deletedLeave.size()==0, 'Leave record should be deleted');
    }


  
    
    @isTest
    static void testDoGet() {
           
    
            
            Employee__c testEmployee = getTestEmployee();

            Leave__c testLeave = new Leave__c();
            testLeave.Name = 'Test Leave';
            testLeave.Type__c= 'Sick';
            testLeave.Description__c= 'des';
            testLeave.Leave_From__c= Date.TODAY();
            testLeave.Leave_To__c=Date.TODAY();
            testLeave.Status__c= 'Submitted for Approval';
            testLeave.Employee_Name__c=testEmployee.id;
            insert testLeave;
    
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
    
            request.requestURI = '/services/apexrest/api/Leave__c/' + testEmployee.Id; // Replace 'yourRestEndpoint' with your actual endpoint
    
            RestContext.request = request;
            RestContext.response = response;
    
            LeaveController.doGet();
    
            System.assertEquals(200, response.statusCode, 'Expected a successful response code');
        
            
            
        }
    
    

























}