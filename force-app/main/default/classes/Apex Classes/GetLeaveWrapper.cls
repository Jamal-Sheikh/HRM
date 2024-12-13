public with sharing class GetLeaveWrapper {
    
    Decimal remainingSickLeaves;
    Decimal remainingWorkFromHomes;
    Integer remainingAnnualLeaves;
    List<Leave__c> pendingLeaves= new List <Leave__c>();
    
    
    
    public GetLeaveWrapper(Decimal sick, Decimal wfh, Integer annual, List<Leave__c> pendingLeaves) {

        this.remainingSickLeaves=sick;
        this.remainingWorkFromHomes=wfh;
        this.remainingAnnualLeaves=annual;
        this.pendingLeaves=pendingLeaves;
    }
}