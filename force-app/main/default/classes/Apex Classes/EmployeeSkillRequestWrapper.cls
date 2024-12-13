public with sharing class EmployeeSkillRequestWrapper {



    
    public String type;
	public String level;
	public String description;
	public String approvalStatus;
    public String skillID;

	
	public static EmployeeSkillRequestWrapper parse(String json) {
		return (EmployeeSkillRequestWrapper) System.JSON.deserialize(json, EmployeeSkillRequestWrapper.class);
	}




}