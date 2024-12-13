public class LeaveWrapper {

	public String name;
	public String type;
	public String year;
	public String fromDate;
	public String toDate;
	public String description;
	public String designation;
	public String leaveNature;
	public String email;

	
	public static LeaveWrapper parse(String json) {
		return (LeaveWrapper) System.JSON.deserialize(json, LeaveWrapper.class);
	}
}