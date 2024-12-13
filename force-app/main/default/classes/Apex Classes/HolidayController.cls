@RestResource(urlMapping='/api/Holiday/*')
global with sharing class HolidayController {
@HttpGet
    //This method return holidays of request parameter year and previous year from request parameter year
global static void getHolidays( ){
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;
    String yearSt = request.requestURI.substring(request.requestURI.lastIndexOf('/') +1);
   // Integer year = Integer.valueOf(yearSt);
   Integer year;
    try {
       year = Integer.valueOf(yearSt);
    } catch (TypeException e){
       year = null;
    }
   if(year !=Null){
     list<Holiday__c> getHolidays = HolidaySelector.getYearlyHolidays(year);
      if(!getHolidays.isEmpty( )){
      response.statusCode = 200;
      response.addHeader('Content-Type', 'application/json');
      String holidayJson = JSON.serialize(getHolidays);
      response.responseBody = Blob.valueOf(holidayJson);
       }
   else{
        response.statusCode = 400;
        response.addHeader('Content-Type', 'application/json');
        String holidayJson = JSON.serialize('Found no holidays related to this year');
        response.responseBody = Blob.valueOf(holidayJson);
    }
}
else{
    response.statusCode = 400;
    response.addHeader('Content-Type', 'application/json');
    String holidayJson = JSON.serialize('Year is missing');
    response.responseBody = Blob.valueOf(holidayJson);
    }
}
}