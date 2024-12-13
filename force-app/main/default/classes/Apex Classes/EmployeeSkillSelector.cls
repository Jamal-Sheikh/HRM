public with sharing class EmployeeSkillSelector {




    public static List<Employee_Skills__c> getSkillsByEmployeeId(String employeeId){

        List <Employee_Skills__c> skillsList = new List <Employee_Skills__c> ();
        
        
        try{

            skillsList= [SELECT Name, Employee__c, Level__c, Type__c, Skill__c, Description__c, Approval_Status__c , Skill__r.Name  FROM Employee_Skills__c WHERE Employee__c=: employeeId];


        }

        catch(exception e){

            System.debug('Error from get skill and certs' +e);


        }


        return skillsList;


    }



    public static List <Employee_Skills__c> getDuplicateSkills(String employeeId, String skillID){


    List <Employee_Skills__c> skillsList = new List <Employee_Skills__c> ();

    
    try{

        skillsList= [SELECT Name FROM Employee_Skills__c WHERE Employee__c=: employeeId AND  Skill__c = : skillID];

    }


    catch(exception e){

        System.debug('Error from get skill and certs' +e);


    }


    return skillsList;





    }







    public EmployeeSkillSelector() {

    }
}