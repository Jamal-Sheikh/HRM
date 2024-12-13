@RestResource(urlMapping='/api/Leave__c/*')
global with sharing  class LeaveController {

    @HttpPost
    global static void doPost() {

        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        LeaveResponseWrapper responseObject = new LeaveResponseWrapper ();
        Integer size = request.requestBody.size();

        try{

        if(size!=0)         

        {
        LeaveWrapper wrapper = LeaveWrapper.parse(request.requestBody.toString());
        
            
        Employee__c emp=LeaveSelector.employeeDetailsGetter(employeeId);
        wrapper.email=emp.Email__c;
        Leave_Quota__mdt leaveQuotaAssigned = LeaveQuotaUtils.leaveQuotaGetter(emp.Designation__c);

        switch on wrapper.type {

            when 'Sick' {

                Integer sickLeaves=Integer.valueOf(leaveQuotaAssigned.Sick_Leaves__c);
                String result=sickLeaveHandler(employeeId, wrapper, sickLeaves);
                responseObject.message=result;
                if( result=='Request already exists ! ' || result=='Invalid request of Sick Leave ' || result=='You do not have enough quota of sick leaves')
                {
                response.statusCode =400;
                responseObject.statusCode='400';
                }
                else{
                    responseObject.statusCode= '200';
                }
                response.responseBody= Blob.valueOf(JSON.serialize(responseObject));
            }	
            when 'Work from Home' {		
               
                Integer workFromHomes=Integer.valueOf(leaveQuotaAssigned.Work_From_Home_s__c);
                String result=workFromHomeHandler(employeeId, wrapper, workFromHomes);
                responseObject.message=result;
                if(result=='Request already exists ! ' || result=='You can only apply for work from home 2 or more days before hand' || result== 'You can not apply Work from homes more than the Quota' )
                {
                response.statusCode =400;
                responseObject.statusCode='400';
                }
                else{
                    responseObject.statusCode= '200';
                }
                response.responseBody= Blob.valueOf(JSON.serialize(responseObject));
            }
            when 'Annual' {

                Integer annualLeaves=Integer.valueOf(leaveQuotaAssigned.Annual_Leaves__c);
                String result=annualLeaveHandler(employeeId, wrapper, annualLeaves);
                responseObject.message=result;
                if(result=='Request already exists ! ' || result== 'You can only apply your annual leave 30 days before the start date!' || result=='You do not have enough quota remaining of the Annual Leaves')
                {
                response.statusCode =400;
                responseObject.statusCode='400';
                }
                else{
                responseObject.statusCode= '200';
                }
                response.responseBody= Blob.valueOf(JSON.serialize(responseObject));
            }
            when 'Emergency' {
                
                String result=emergencyLeaveHandler(employeeId, wrapper);
                responseObject.message=result;
                if(result=='Request already exists ! ') {
                response.statusCode =400;
                responseObject.statusCode='400';
                }
                else {
                    responseObject.statusCode= '200';
                }
                
                response.responseBody= Blob.valueOf(JSON.serialize(responseObject));
            }

            when else {
  

                response.statusCode =400;
                responseObject.message='Not a valid type of leave';
                responseObject.statusCode='400';
                response.responseBody= Blob.valueOf(JSON.serialize(responseObject));


            }

        }}
       
        else {


            response.statusCode =400;
            responseObject.message='The request body is empty';
            responseObject.statusCode='400';
            response.responseBody= Blob.valueOf(JSON.serialize(responseObject));

        }}

        catch(exception e){

            System.debug('Error occured is ' +e);
        }

}


//This method handles the delete leave request from the api

@HttpDelete
global static void deleteLeave() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    String Id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    
    List <Leave__c> result = LeaveSelector.deleteLeave(Id);
    if(result.size()>0){
    delete result;

    response.statusCode =200;
    response.responseBody= Blob.valueOf(JSON.serialize('Successfully Deleted!'));}

    else {
    response.statusCode =400;
    response.responseBody= Blob.valueOf(JSON.serialize('Not a valid leave'));

    }

}



//This method handles the get request of remaining sick, annual, WFH along with submitted and approved leaves of last 30 days 

@HttpGet
global static void doGet() {

    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;
    String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

    Employee__c emp=LeaveSelector.employeeDetailsGetter(employeeId);
    Leave_Quota__mdt leaveQuotaAssigned = LeaveQuotaUtils.leaveQuotaGetter(emp.Designation__c);

    
    //WFH and Sick
    Date dayToEnd= Date.TODAY();  
    Integer year = dayToEnd.year();  
    Integer month = dayToEnd.month();
    Integer numberDays = date.daysInMonth(year,month); //handling the months with 30 and 31 days
    dayToEnd= date.newInstance(year, month, numberDays);
    Date dayToStart= dayToEnd.toStartOfMonth(); // going to start of this month to check the leaves taken already
    List <String> status = new List <String>  {'Approved'};
    List <String> typeOfLeaves = new List <String>  {'Work From Home','Sick'};

    List<Leave__c> sickAndWFH = LeaveSelector.getLeavesByDate (employeeId, dayToStart, dayToEnd, typeOfLeaves, status);


    List <Leave__c> sickLeaves = new List <Leave__c>();
    List <Leave__c> workFromHomes = new List <Leave__c>();
    

    for ( Leave__c a: sickAndWFH )
    {
        if(a.Type__c=='Sick')
        {
            sickLeaves.add(a);
            continue;
        }
        
        workFromHomes.add(a); 
    }

   
    Decimal sickCount = SickAndWFHDaysCounter(sickLeaves);
    Decimal wfhCount = SickAndWFHDaysCounter(workFromHomes);

    sickCount = leaveQuotaAssigned.Sick_Leaves__c - sickCount;
    wfhCount = leaveQuotaAssigned.Work_From_Home_s__c - wfhCount;

    //annual

    List<String> annualStatus = new List <String> {'Approved'};
    List <String> annualTypeList = new List <String>  {'Annual'};
    
    Integer yearAnnual = dayToEnd.year();
    dayToStart = Date.newInstance(yearAnnual,1,1);
    dayToEnd= Date.newInstance(yearAnnual,12,31);

    List<Leave__c> annualLeaves = LeaveSelector.getLeavesByDate(employeeId, dayToStart ,dayToEnd , annualTypeList, annualStatus);

    Integer annualCount= DaysCounter(annualLeaves);

    annualCount= Integer.valueOf(leaveQuotaAssigned.Annual_Leaves__c) - annualCount;

    
    //Pending Leave requests
    List <Leave__c> pendingLeaves = LeaveSelector.getPendingAndApprovedLeaves(employeeId);
    response.statusCode =200;

    //preparing response
    GetLeaveWrapper getResponse=  new GetLeaveWrapper(sickCount, wfhCount, annualCount, pendingLeaves);
    response.responseBody=Blob.valueOf(JSON.serialize(getResponse)); 
}


//this method counts the days of leave requests

public static Integer DaysCounter(List <Leave__c> leavesCount ){


    Integer daysCount=0;

    for (Leave__c a: leavesCount )
    { 
       Integer days = a.Leave_From__c.daysBetween(a.Leave_To__c); 

       days++;

       daysCount+=days;
    }

    return daysCount;
 }

 
 public static Decimal SickAndWFHDaysCounter(List <Leave__c> leavesCount ){

    Decimal daysCount=0;

    for (Leave__c a: leavesCount )
    { 
       if(a.Leave_Nature__c=='Half Day')
       {
       Decimal days = a.Leave_From__c.daysBetween(a.Leave_To__c); 
       days++;
       days=days/2;   //handling half days
       daysCount+=days;
       }

       else
       {
       Integer days = a.Leave_From__c.daysBetween(a.Leave_To__c); 
       days++;
       daysCount+=days;
       }
    }

    return daysCount;
 }


 

//handles the sick leave application request

public static String sickLeaveHandler(String employeeId, LeaveWrapper wrapper, Integer Quota){

        Date startDate=  Date.valueOf(wrapper.fromDate);
        Date endDate= Date.valueOf(wrapper.toDate);

        Integer numberDaysDue = date.today().daysBetween(startDate);
        Integer duration= startDate.daysBetween(endDate);


        Date dayToEnd= Date.TODAY();
        Integer year = dayToEnd.year();
        Integer month = dayToEnd.month();
        Integer numberDays = date.daysInMonth(year,month);
        dayToEnd= date.newInstance(year, month, numberDays);


        Date dayToStart= dayToEnd.toStartOfMonth();
        List <String> status = new List <String>  {'Approved'};
        List <String> typeOfLeaves = new List <String>  {'Sick'};
       
        List<Leave__c> sickLeaves = LeaveSelector.getLeavesByDate (employeeId, dayToStart, dayToEnd, typeOfLeaves, status);
        Decimal totaldays = SickAndWFHDaysCounter(sickLeaves);

        Decimal remainingQuota = Quota- totaldays; 

        if(numberDaysDue>1){

            return 'Invalid request of Sick Leave ';
        }
        if(duration>=remainingQuota)
        {
            return 'You do not have enough quota of sick leaves';
        }

        String successMessage = leaveCreator(employeeId, wrapper);
        return successMessage;

    }

    //handles the annual leave application request

    public static String annualLeaveHandler(String employeeId, LeaveWrapper wrapper, Integer Quota){

        Date startDate=  Date.valueOf(wrapper.fromDate);
        Date endDate= Date.valueOf(wrapper.toDate);

        Integer numberDaysDue = date.today().daysBetween(startDate);
        Integer duration= startDate.daysBetween(endDate);

        List<String> annualStatus = new List <String> {'Approved'};
        List <String> annualTypeList = new List <String>  {'Annual'};
        Date dayToEnd =Date.TODAY();
        Integer year = dayToEnd.year();
        dayToEnd=Date.newInstance(year,12,31);
        Date dayToStart = Date.newInstance(year,1,1);
        List<Leave__c> annualLeaves = LeaveSelector.getLeavesByDate (employeeId, dayToStart , dayToEnd, annualTypeList, annualStatus);
        Integer annualCount= DaysCounter(annualLeaves);

      
        Integer remainingQuota = Integer.valueOf(Quota)- annualCount ;    

        if(numberDaysDue<30)
        {
         return 'You can only apply your annual leave 30 days before the start date!';
        }

        if(duration>=remainingQuota)
        {
         return 'You do not have enough quota remaining of the Annual Leaves';
        }

        String successMessage = leaveCreator(employeeId, wrapper);
        return successMessage;
    }


   //handles the WFH application request
    public static String workFromHomeHandler(String employeeId, LeaveWrapper wrapper, Integer Quota){

        Date startDate=  Date.valueOf(wrapper.fromDate);
        Date endDate= Date.valueOf(wrapper.toDate);

        Integer numberDaysDue = date.today().daysBetween(startDate);
        Integer duration= startDate.daysBetween(endDate);

        Date dayToEnd= Date.TODAY();
        Integer year = dayToEnd.year();
        Integer month = dayToEnd.month();
        Integer numberDays = date.daysInMonth(year,month);
        dayToEnd= date.newInstance(year, month, numberDays);

        Date dayToStart= dayToEnd.toStartOfMonth();
        List <String> status = new List <String>  {'Approved'};
        List <String> typeOfLeaves = new List <String>  {'Work From Home'};
        
    
        List<Leave__c> workFromHomes = LeaveSelector.getLeavesByDate (employeeId, dayToStart, dayToEnd, typeOfLeaves, status);

        Decimal totaldays = SickAndWFHDaysCounter(workFromHomes);

        Decimal remainingQuota = Quota - totaldays; 
        

        if (numberDaysDue<2){
            return 'You can only apply for work from home 2 or more days before hand';
        }

        if(duration>=remainingQuota){

            return 'You can not apply Work from home more than the Quota';
        }
        
        String successMessage = leaveCreator(employeeId, wrapper);
        return successMessage;
    }

    //handles the emergency leave application request

    public static String emergencyLeaveHandler (String employeeId, LeaveWrapper wrapper){

        String successMessage = leaveCreator(employeeId, wrapper);
        return successMessage;
    }


    
    //this method is called to create a leave request by the above methods
    public static String leaveCreator(String employeeId, LeaveWrapper wrapper){

        List <Leave__c> sameLeave = LeaveSelector.getAppliedLeavesByDate(employeeId,wrapper.fromDate,wrapper.toDate);

        if(sameLeave.size()==0){
        Leave__c LeaveRequest = new Leave__c();

        LeaveRequest.Name= wrapper.name;
        LeaveRequest.Type__c= wrapper.type;
        LeaveRequest.Description__c= wrapper.description;
        LeaveRequest.Leave_From__c= Date.valueOf(wrapper.fromDate);
        LeaveRequest.Leave_To__c=Date.valueOf(wrapper.toDate);
        LeaveRequest.Status__c= 'Submitted for Approval';
        LeaveRequest.Employee_Name__c=employeeId;
        LeaveRequest.Leave_Nature__c=wrapper.leaveNature;
        LeaveRequest.Email__c=wrapper.email;

        insert LeaveRequest;

        approvalProcess(LeaveRequest);

        return 'Request Successfully Submitted ! ';}


        else{

            return 'Request already exists ! ';
        }

     }


     //This method starts the approval process
     public static void approvalProcess(Leave__c leave){
        
        // Create an approval request 
        Approval.ProcessSubmitRequest request =   new Approval.ProcessSubmitRequest();
        request.setComments('Submitting request for approval.');
        request.setObjectId(leave.id);
        // Submit on behalf of a specific submitter
        request.setSubmitterId(leave.ownerid);
        // Submit the record to specific process and skip the criteria evaluation
        request.setProcessDefinitionNameOrId('Leave_Approval1');
        request.setSkipEntryCriteria(true);
        System.debug(request);
        // Submit the approval request 
        Approval.ProcessResult result = Approval.process(request);


     }


}