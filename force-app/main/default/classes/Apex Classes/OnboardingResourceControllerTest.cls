@isTest
private class OnboardingResourceControllerTest {

    static Employee__c createTestEmployee() {
        Employee__c testEmployee = new Employee__c(
            Name = 'TestEmployee',
            Email__c = 'TestEmployee@gmail.com',
            Mobile__c = '1234556',
            Password__c = '12345',
            UserName__c = 'TestEmployee'
        );
        insert testEmployee;
        return testEmployee;
    }

    @isTest
    static void testOnboardingRet() {
        // Create a test employee
        Employee__c testEmployee = createTestEmployee();

        // Create a test onboarding resource
        Onboarding_Resource__c onboardingResource = new Onboarding_Resource__c(
            Name = 'Test Onboarding Resource',
            Subject__c = 'Test Subject',
            Description__c = 'Test Description',
            Level__c = 'Level-I',
            Link__c = 'https://example.com',
            Status__c = 'Active'
        );
        insert onboardingResource;

        // Create a test resource completion
        Resource_Completion__c resourceCompletion = new Resource_Completion__c(
            Employee__c = testEmployee.Id,
            Onboarding_Resource__c = onboardingResource.Id,
            Status__c = 'Completed'
        );
        insert resourceCompletion;

        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/OnboardingResource/' + testEmployee.Id;
        RestContext.request = request;
        RestContext.response = response;

        OnboardingResourceController.OnboardingRet();

        Test.stopTest();

       
        System.assertEquals(200, response.statusCode);
        
    }

    @isTest
    static void testCreateResourceCompletion() {
        // Create a test employee
        Employee__c testEmployee = createTestEmployee();

        // Create a test onboarding resource
        Onboarding_Resource__c onboardingResource = new Onboarding_Resource__c(
            Name = 'Test Onboarding Resource',
            Subject__c = 'Test Subject',
            Description__c = 'Test Description',
            Level__c = 'Level-I',
            Link__c = 'https://example.com',
            Status__c = 'Active'
        );
        insert onboardingResource;

        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/OnboardingResource';
        request.requestBody = Blob.valueOf('{"EmployeeID": "' + testEmployee.Id + '", "OnboardingResourceID": "' + onboardingResource.Id + '", "Status": "Completed"}');
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;

        OnboardingResourceController.createResourceCompletion();

        Test.stopTest();

        
        System.assertEquals(200, response.statusCode);
        
    }

    @isTest
    static void testCreateResourceCompletionWithExistingRecord() {
        // Create a test employee
        Employee__c testEmployee = createTestEmployee();

        // Create a test onboarding resource
        Onboarding_Resource__c onboardingResource = new Onboarding_Resource__c(
            Name = 'Test Onboarding Resource',
            Subject__c = 'Test Subject',
            Description__c = 'Test Description',
            Level__c = 'Level-I',
            Link__c = 'https://example.com',
            Status__c = 'Active'
        );
        insert onboardingResource;

        // Create a test resource completion
        Resource_Completion__c resourceCompletion = new Resource_Completion__c(
            Employee__c = testEmployee.Id,
            Onboarding_Resource__c = onboardingResource.Id,
            Status__c = 'Completed'
        );
        insert resourceCompletion;

        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/OnboardingResource';
        request.requestBody = Blob.valueOf('{"EmployeeID": "' + testEmployee.Id + '", "OnboardingResourceID": "' + onboardingResource.Id + '", "Status": "Completed"}');
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;

        OnboardingResourceController.createResourceCompletion();

        Test.stopTest();

       
        System.assertEquals(400, response.statusCode);
        
    }

    @isTest
    static void testCreateResourceCompletionWithInvalidRequest() {
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/OnboardingResource';
        request.requestBody = Blob.valueOf('{}');
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;

        OnboardingResourceController.createResourceCompletion();

        Test.stopTest();

       
        System.assertEquals(400, response.statusCode);
        
    }
}