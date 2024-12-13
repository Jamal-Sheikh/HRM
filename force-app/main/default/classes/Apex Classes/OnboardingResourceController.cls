@RestResource(urlMapping='/api/OnboardingResource/*')
global without sharing class OnboardingResourceController {
    @HttpGet
    global static void OnboardingRet() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        OnboardingResourceWrapper responseObj = new OnboardingResourceWrapper();
        String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        List<Onboarding_Resource__c> onboardingResourceList = OnboardingResourceSelector.getOnboadingResources(employeeId);
        if(onboardingResourceList.isEmpty()){
            
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            responseObj.message= 'Invalid Input';
            responseObj.statusCode= '400';
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
        }
        else{
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(JSON.serialize(onboardingResourceList));
        }
    }
    @HttpPost
    global static void createResourceCompletion() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        OnboardingResourceWrapper responseObj = new OnboardingResourceWrapper();  
        
        Map<String, Object> requestData = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        createResourceCompletionWrapper wrapper = new createResourceCompletionWrapper(requestData);
        
        // Add SOQL query to check for an existing record
        List<Resource_Completion__c> existingRecord = OnboardingResourceSelector.existingRecord( wrapper.employeeID ,  wrapper.onboardingResourceID);
        
        if (existingRecord.size() != 0) {
            // A record with the same criteria already exists
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            responseObj.message= 'Record already exists';
            responseObj.statusCode= '400';
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            
            
            
        } else if (requestData.containsKey('EmployeeID') && requestData.containsKey('OnboardingResourceID') && requestData.containsKey('Status')) {
            // Create a new Resource Completion record
            Resource_Completion__c resComp = new Resource_Completion__c();
            resComp.Employee__c = wrapper.employeeID;
            resComp.Onboarding_Resource__c = wrapper.onboardingResourceID;
            resComp.Status__c = wrapper.status;
            insert resComp;
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            
            responseObj.message= 'Record Created ';
            responseObj.statusCode= '200';
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            
            
        } else {
            // Invalid request data
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            
            responseObj.message= 'Invalid request data. ';
            responseObj.statusCode= '400';
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            
            
            
            
        }
    }
}