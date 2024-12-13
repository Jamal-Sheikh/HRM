@RestResource(urlMapping='/api/Employee_Skills__c/*')

global with sharing class EmployeeSkills {



    @HttpPost
    global static void doPost() {

        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Integer size = request.requestBody.size();
        
        EmployeeSkillsResponseWrapper responseWrapper = new EmployeeSkillsResponseWrapper ();

        try{
         EmployeeSkillRequestWrapper wrapper = EmployeeSkillRequestWrapper.parse(request.requestBody.toString());


        if(size>0){

          if(duplicateSkillCheck(employeeId,wrapper.skillID)){

          response.statusCode =400;
          responseWrapper.message= 'Request Already Exists';
          responseWrapper.statusCode='400';
          response.responseBody= Blob.valueOf(JSON.serialize(responseWrapper));

          }

          else{
          String result= employeeSkillCreator(employeeId,wrapper);
          responseWrapper.message= result;
          responseWrapper.statusCode='200';
          response.responseBody= Blob.valueOf(JSON.serialize(responseWrapper));}

        }

        else {

          response.statusCode =400;
          responseWrapper.message= 'Invalid Input';
          responseWrapper.statusCode='400';
          response.responseBody= Blob.valueOf(JSON.serialize(responseWrapper));

        }
    
    
    }

    catch (exception e){


        System.debug('Error Occured is ' +e);
    }


    }




    @HttpGet
    global static void doGet() {


        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        EmployeeSkillsResponseWrapper responseWrapper = new EmployeeSkillsResponseWrapper ();


        List <Employee_Skills__c> skillsList= new List <Employee_Skills__c> ();

            skillsList=EmployeeSkillSelector.getSkillsByEmployeeId(employeeId);

            if(skillsList.size()==0) {

            response.statusCode =400;
            responseWrapper.statusCode='400';
            responseWrapper.message='No Skills Found';    

            response.responseBody= Blob.valueOf(JSON.serialize(responseWrapper));}

            else {

            responseWrapper.statusCode='200';
            responseWrapper.message='Success';   
            responseWrapper.skillsList.addAll(skillsList);    
            
            response.responseBody= Blob.valueOf(JSON.serialize(responseWrapper));

            }


        }



    public static Boolean duplicateSkillCheck(String employeeId, String skillID){


        List <Employee_Skills__c> skillsList = EmployeeSkillSelector.getDuplicateSkills(employeeId,skillID);

        if(skillsList.size()>0)
        {
            return true;
        }

        return false;


    }    


    public static String employeeSkillCreator(String employeeId, EmployeeSkillRequestWrapper wrapper ){


            Employee_Skills__c employeeSkill = new Employee_Skills__c();
            employeeSkill.Employee__c=employeeId;
            employeeSkill.Type__c=wrapper.type;
            employeeSkill.Description__c= wrapper.description;
            employeeSkill.Level__c=wrapper.level;
            employeeSkill.Approval_Status__c='Pending';
            employeeSkill.Skill__c=wrapper.skillID;
    
            insert employeeSkill;
    
            approvalProcess(employeeSkill);
    
            return 'Success';
            
        }





        
    public static void approvalProcess( Employee_Skills__c employeeSkill){
        
        // Create an approval request 
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setComments('Submitting request for approval.');
        request.setObjectId(employeeSkill.id);
        // Submit on behalf of a specific submitter
        request.setSubmitterId(employeeSkill.ownerid);
        // Submit the record to specific process and skip the criteria evaluation
        request.setProcessDefinitionNameOrId('Employee_Skill_Approval');
        request.setSkipEntryCriteria(true);
        System.debug(request);
        // Submit the approval request 
        Approval.ProcessResult result = Approval.process(request);


     }














    public EmployeeSkills() {

    }
}