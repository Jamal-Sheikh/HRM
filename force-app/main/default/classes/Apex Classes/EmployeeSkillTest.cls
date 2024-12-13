@isTest
public with sharing class EmployeeSkillTest {


    @TestSetup
    public static void createTestEmployeeAndSkill(){

        createTestEmployee();
        createTestSkill();
    }


    public static void createTestEmployee(){

        Employee__c testEmployee = new Employee__c();
        testEmployee.Name = 'Test Class created employee';
        testEmployee.Email__c = 'testclass@gmail.com';
        testEmployee.Mobile__c = '090078602';
        testEmployee.Password__c = 'testEmployee@example.com';
        testEmployee.UserName__c = 'User101';
        testEmployee.Designation__c= 'Manager';

        insert testEmployee;

    }

    public static void createTestSkill(){

    
        Skill__c testSkill = new Skill__c ();
        testSkill.Name= 'Test Skill';
        testSkill.Description__c='abc';

        insert testSkill;
    }


    public static Employee__c getTestEmployee(){

        Employee__c testEmployee= [SELECT Id FROM Employee__c WHERE Mobile__c = '090078602'];
        return testEmployee;


    }

    public static Skill__c getTestSkill(){

        Skill__c  testSkill= [SELECT Id, Name FROM Skill__c WHERE Name = 'Test Skill'];
        return testSkill;


    }


    @isTest
    static void testPostEmployeeSkill() {
        
        Employee__c testEmployee = getTestEmployee();
        Skill__c testSkill = getTestSkill();
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Employee_Skills__c/' + testEmployee.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"type": "Certified", "skillID": "'+testSkill.Id+'", "level": "Intermediate", "description": "asdfg", "approvalStatus": "Pending" }');

        RestContext.request = req;
        RestContext.response = res;

        EmployeeSkills.doPost();
        System.debug('Response Body: ' + res.responseBody.toString());

        Assert.isTrue(res.responseBody.toString().contains('200'), 'True It contains the correct response ');

    }


    @isTest
    static void testGetSkillCert() {
        
        Employee__c testEmployee = getTestEmployee();
        Skill__c testSkill =getTestSkill();
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/api/Employee_Skills__c/' + testEmployee.Id;
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;

        

        employeeSkillCreator(testEmployee.id, testSkill.id);
        EmployeeSkills.doGet();
        System.debug('Response Body: ' + res.responseBody.toString());

        

        Assert.isTrue(res.responseBody.toString().contains('200'), 'True It contains the correct response ');

    }




    public static void employeeSkillCreator(Id employeeId, Id skillID)
    {

        Employee_Skills__c testEmployeeSkill = new Employee_Skills__c();
        testEmployeeSkill.Skill__c=skillID;
        testEmployeeSkill.Employee__c=employeeId;
        testEmployeeSkill.Level__c='Beginner';
        testEmployeeSkill.Type__c='Certified';

        insert testEmployeeSkill;


    }



















    public EmployeeSkillTest() {

    }
}