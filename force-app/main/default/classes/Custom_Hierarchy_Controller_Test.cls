@isTest
public class Custom_Hierarchy_Controller_Test {
    @testsetup public static void testDataSetup(){
        Hierarchy__c parentRecord = new Hierarchy__c(Name='Parent Record');
        insert parentRecord;
       /* Hierarchy__c childRecord = new Hierarchy__c(Name='Child Record',Parent_Record__c =parentRecord.Id );
        insert childRecord;*/
    }
 /**************************************************************************************
@ Method:         testfindHierarchyData   
@ Purpose:        This is test method to call Controller method to get list of Records in the Hierarchy
Asserts :		  Assert if all records in hierarchy are returne
*************************************************************************************/    
    public static testmethod void testfindHierarchyData(){
        Hierarchy__c parentRecord = [SELECT Id FROM Hierarchy__c WHERE Name= 'Parent Record'];
        Hierarchy__c childRecord = [SELECT Id FROM Hierarchy__c WHERE Name= 'Child Record'];
        Custom_Hierarchy_Controller.getColumnDefinitions();
        List<SObject> listRecords =Custom_Hierarchy_Controller.findHierarchyData(String.valueOf(childRecord.Id));
        //Assert if all records in hierarchy are returned
        System.assert(listRecords.size() == 2);
    }
}