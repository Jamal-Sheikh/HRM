public with sharing class HolidaySelector {
    public static list<Holiday__c> getYearlyHolidays(Integer year ){

        Integer previousYear = year - 1;
        list<Holiday__c> getholidays = [Select 	Name, Date__c, 	Description__c, Kind__c, Year__c from Holiday__c WHERE Year__c =: year OR Year__c = :previousYear ORDER BY Year__c];
        return getholidays;
    }
}