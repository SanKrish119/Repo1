({
	callToServer : function(component, method, callback, params) {
        
		var action = component.get(method);
        if(params){
            action.setParams(params);
        }
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = response.getReturnValue();
            if (state === "SUCCESS" && responseValue[0]!=null) {
                callback.call(this,response.getReturnValue());
            }else if(state === "SUCCESS"){
                component.set('v.errorOnLimit',true);
            }else if(state === "ERROR") {
                alert('Error in Connection');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
})