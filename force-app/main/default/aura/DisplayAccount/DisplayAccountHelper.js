({
                
                doInit : function(component, event, helper) {
        
        var action = component.get("c.getAccounts");
         action.setParams({
            "productId"   : component.get('v.recordId'),                                     
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var AccountLists = response.getReturnValue();
                component.set("v.Accounts", AccountLists);
                
            }
         });
         
        $A.enqueueAction(action);
    }
                     
})