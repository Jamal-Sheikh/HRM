@isTest
public with sharing class HolidayTest {
    @TestSetup
    static void DemoData( ){
        Holiday__c testHoliday = new Holiday__c( Name = 'Independence Day',  Date__c = Date.newInstance(2022, 14, 8),  Description__c = 'Holiday of 14 August',
            Kind__c = 'Full Day',  Year__c = 2022 );
         insert testHoliday;
    }
    @isTest
    public static void getAllHolidays( ){
        RestRequest request = new RestRequest( );
        RestResponse response = new RestResponse( );
        Holiday__c testDataHoliday = [Select Name, Date__c, Description__c, Kind__c, Year__c from Holiday__c wHERE Name = 'Independence Day' ];
        request.requestURI = '/services/apexrest/api/Holiday/' + testDataHoliday.Year__c;
        RestContext.request = request;
        RestContext.response = response;
        HolidayController.getHolidays( );
        system.assertEquals(200, response.statusCode);
        list<Holiday__c> responseBody = (list<Holiday__c>)JSON.deserialize(response.responseBody.toString( ),list<Holiday__c>.class);
        system.assertEquals(testDataHoliday.Name, responseBody[0].Name);
        system.assertEquals(testDataHoliday.Description__c, responseBody[0].Description__c);
    }
    
     @isTest 
    public static void getnoHolidays( ){
        RestRequest request = new RestRequest( );
        RestResponse response = new RestResponse( );
        request.requestURI = '/services/apexrest/api/Holiday/' + 2019;
        RestContext.request = request;
        RestContext.response = response;
        HolidayController.getHolidays( );
        system.assertEquals(400, response.statusCode);
        string json = response.responseBody.toString( ).replaceAll('"','');
        system.assertEquals('Found no holidays related to this year', json);
    }

    @isTest
    public static void noGetHolidays( ){
        RestRequest request = new RestRequest( );
        RestResponse response = new RestResponse( );
        request.requestURI = '/services/apexrest/api/Holiday';
        request.requestBody = blob.valueOf('{ }');
        RestContext.request = request;
        RestContext.response = response;
        HolidayController.getHolidays( );
        system.assertEquals(400, response.statusCode);
        string json = response.responseBody.toString( ).replaceAll('"','');
        system.assertEquals('Year is missing', json);
    }
}