@isTest
public class EmployeeTest {
    @TestSetup
    static void DemoData( ){
        Employee__c testEmployee = new Employee__c(Name ='Abdullah', Email__c = 'Abdullah123@gmail.com', Mobile__c = '12359999', Password__c = '564321',
        Designation__c= 'Manager', UserName__c = 'Abd@gmail.com', Profile_Image__c = 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Fuser%2F&psig=AOvVaw3PxFijEmmBDd-Bg0voXMAx&ust=1706955047049000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCMDD5py1jIQDFQAAAAAdAAAAABAD' );
    insert testEmployee;
    }
    @isTest
    static void testEmployeeDetailsGet( ){
        Employee__c TestDataEmployee = [SELECT Id, Name, Email__c, Mobile__c, Password__c, Designation__c, UserName__c, Profile_Image__c from Employee__c WHERE Name ='Abdullah'];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/Employee/' + TestDataEmployee.Id;
        RestContext.request = request;
        RestContext.response = response;
        EmployeeController.employeeDetailsGet( );
        System.assertEquals(200, response.statusCode);
        Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.responseBody.toString());
        System.assertEquals(testDataEmployee.Name, responseBodyMap.get('Name'));
}
       @isTest
    static void testEmployeeDetailsNoId() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/Employee/';
        RestContext.request = request;
        RestContext.response = response;
        EmployeeController.employeeDetailsGet();
        System.assertEquals(400, response.statusCode);
        String responseBodyString = response.responseBody.toString( ).replaceAll('"', '');
        System.assertEquals('Invalid employeeId', responseBodyString);
    }
}