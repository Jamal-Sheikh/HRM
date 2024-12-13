public class OnboardingResourceSelector {
    public static List<Onboarding_Resource__c> getOnboadingResources(string employeeId){
        List<Onboarding_Resource__c> onboardingResourceList = [
                SELECT Name, Subject__c, Description__c, status__c, Level__c, Link__c,
                (SELECT Name, Employee__c, onboarding_resource__c, Status__c FROM Resource_Completions__r WHERE Status__c = 'Completed' and Employee__c=:employeeId)
                FROM Onboarding_Resource__c WHERE Status__c = 'Active' Order by Level__c
            ];
        return onboardingResourceList;
    }
    
       public static List<Resource_Completion__c> existingRecord(string employeeID ,  string onboardingResourceID){
      List<Resource_Completion__c> existingRecord = [SELECT Id FROM Resource_Completion__c 
                                             WHERE Employee__c = :employeeID 
                                             AND Onboarding_Resource__c = :onboardingResourceID 
                                             LIMIT 1];
             return existingRecord;
}
  
}