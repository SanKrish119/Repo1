public class ShowAccountsOfProducts {
 @AuraEnabled
    public static List<Asset> getAccounts(Id productId) {
        List<Asset> AssetList = new List<Asset>();
        List<Asset> AccountList = new List<Asset>();
        List<Account> AccountDetailsList = new List<Account>();     
        /*System.debug('456'+productId);
        String sQuery =  'select Id from Asset where Product2Id=: productId';
       List < Asset > lstOfRecords = Database.query(sQuery);    
        for (Asset obj: lstOfRecords) {
            AssetList.add(obj);       
                }   */
        String sQuery1 =  'select Id,Name,Account.Name,Account.Id from Asset where Product2Id=: productId';
           AccountList = Database.query(sQuery1);  
        
        /*for (Asset obj1: lstOfRecords1) {
            AccountList.add(obj1);       
        }  */ 
        return AccountList;
    }
}