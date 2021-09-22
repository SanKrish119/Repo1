/*
Class Name : Custom_Hierarchy_Controller
Created By: Sanjeev GIT
Description : Display Hierarchy Table based on  Parent field .
*/
public without sharing class Custom_Hierarchy_Controller {
    
    //Map to store  Parent ID to List of child Accounts
     private static Map<Id,List<SObject>> mapAccToLstChild = new  Map<Id,List<SObject>>();
    //List to return to Aura for setting in TreeGrid
     private static List<SObject> finalListToReturn = new List<SObject>();
     public static List<String> fieldList = new List<String>();
     public static String ObjectAPI = System.Label.Custom_Hierarchy_Object_API;
/*
Method Name : findHierarchyData
Input : Record Id of Record from where the Aura is called.
Output : List<SObject> finalListToReturn.
Description : Return all records under the Ultimate Parent in a list which contains all Records in hierarchical order.
*/
    @AuraEnabled
    public static List<SObject> findHierarchyData(String recId){
        try{
        String query;
        String query2;
        
        Custom_hierarchy_fields_to_query__mdt metadata =[SELECT Fields__c,Parent_Record_field_API__c ,Ultimate_Record_Field_API__c
                                                         FROM Custom_hierarchy_fields_to_query__mdt LIMIT 1];
        query = 'select Id,' + metadata.Fields__c+','+metadata.Parent_Record_field_API__c + ','+metadata.Ultimate_Record_Field_API__c+' from ' + ObjectAPI + ' where Id =:recId';
        String parentFieldAPI = metadata.Parent_Record_field_API__c;
        String ultimateParentAPI = metadata.Ultimate_Record_Field_API__c;
        //Current Record Details.
        Sobject Record = Database.query(query);
        //Store Field values
        String  ultimateParentValue = (String) Record.get(ultimateParentAPI);
        String parentFieldValue = (String) Record.get(parentFieldAPI);
        
        query2 = 'SELECT Id,'+ metadata.Fields__c+','+metadata.Parent_Record_field_API__c +','+metadata.Ultimate_Record_Field_API__c+ ' from ' + ObjectAPI + ' Where '+metadata.Ultimate_Record_Field_API__c +' =:';
        if(Record.get(ultimateParentAPI)!=null){
            query2 = query2 + ' ultimateParentValue OR Id =: ultimateParentValue LIMIT 49999';
        }else{
             query2 = query2 + ' parentFieldValue OR Id =: parentFieldValue LIMIT 49999';
        } 
        
        List<Sobject> listRecords = Database.query(query2);
        // Retrieve all Records in the hierarchy using the Ultimate Parent field of the Object. 
        //    - If Current Record have Ultimate parent field populated as same record it is considered 
        //      the Ultimate parent and Record Id is directly used
        //    - If current Record have Ultimate parent,Ultimate Parent value is used and hierachy is retrieved
        //    - To get the Ultimate Parent details also, Query is filtered with Id field with same above mentioned conditions.
        for(Sobject rec: listRecords){
                              //If the retrived Record have the Ultimate Parent populated as same,
                              //then it is the Ultimate parent of the Hierarchy 
                              //and is added as the first element in the final list to return.
                              if(rec.get(ultimateParentAPI)==rec.Id){
                                  finalListToReturn.add(rec);
                              }
                              //Add other Records from the hierarchy to map of parent to the List of child Records
                              else if(mapAccToLstChild.containsKey((Id)rec.get(metadata.Parent_Record_field_API__c))){
                                  mapAccToLstChild.get((Id)rec.get(parentFieldAPI)).add(rec);
                              }else{
                                  mapAccToLstChild.put((Id)rec.get(parentFieldAPI),new List<SObject>{rec});
                              }
                          }
        
        //pass Ultimate Parent to recurssive class to get all child Records under it.
        addChildRecords(finalListToReturn);
        return finalListToReturn;
        }
        catch(exception exp){
            system.debug('Exception : '+exp.getMessage());
            return null;
        }
    }

/*Method Name : addChildRecords
Input : List<Account> Records
Description : Recurssive class which loops to get all child Records for each level and adds to final list.
*/
    public static void addChildRecords( List<SObject> Records ){ 
        
        //Temporary list to store child Records of present level Records
        List<SObject> childRecords = new List<SObject>();
        //loop the list to get child Records from the map and adding to temporary list
        for(SObject acc : Records)
        {
            if(mapAccToLstChild.containskey(acc.Id)){
                childRecords.addALL(mapAccToLstChild.get(acc.Id));
            }
        }
        if(!childRecords.isEmpty()){
            //Add the list to the final list and loop the class again to get next level child Records until there are no child accounts
            finalListToReturn.addAll(childRecords);
            addChildRecords(childRecords);
        }
    }
 /*Method Name : getColumnDefinitions
Input : List<ColumnDefinition> Records
Description : Returns the list of wrapper class which has field definitions to dynamically create datatable column.
*/   
    @AuraEnabled public static List<ColumnDefinition> getColumnDefinitions() {
        Custom_hierarchy_fields_to_query__mdt metadata =[SELECT Fields__c,Parent_Record_field_API__c 
                                                         FROM Custom_hierarchy_fields_to_query__mdt LIMIT 1];
        
        List<String> fieldList = metadata.Fields__c.replaceAll('\\s+', '').split(',');
        List<ColumnDefinition> columnDefinitions = new List<ColumnDefinition>();

        //Get Object API information
        Schema.DescribeSObjectResult objectDescribe = Schema.describeSObjects(new String[]{ObjectAPI}).get(0);

        //Get field API information from object field map
        Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
        for(String field : fieldList) {
            if(fieldMap.containsKey(field)) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(field).getDescribe();
                ColumnDefinition cd = new ColumnDefinition(fieldDescribe.getLabel(), field,
                        String.valueOf(fieldDescribe.getType()));
                columnDefinitions.add(cd);
            }
        }

        return columnDefinitions;
    }
/*Class Name : ColumnDefinition
Description : Wrapper class to create column in Datatable.
*/     
    public class ColumnDefinition {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public cellAttributesClass cellAttributes = new cellAttributesClass();
        public ColumnDefinition(String label, String fieldName, String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
        }
    }
    public class cellAttributesClass{
        @AuraEnabled
        Public string iconPosition;
        @AuraEnabled 
        public iconNameClass iconName = new iconNameClass();
        public cellAttributesClass(){
            this.iconPosition = 'right';
        }
    }
    public class iconNameClass{
        @AuraEnabled
        public String fieldName;
        public iconNameClass(){
            this.fieldName='trendIcon';
        }
    }
   
}