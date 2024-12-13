public with sharing class LeaveQuotaUtils {



    public static Leave_Quota__mdt leaveQuotaGetter(String designation){

        
        Leave_Quota__mdt metaDataReturn= Leave_Quota__mdt.getInstance(designation);
        return metaDataReturn;
    }



    public LeaveQuotaUtils() {

    }
}