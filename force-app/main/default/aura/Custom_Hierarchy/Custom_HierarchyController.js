({
	 doInit: function (component, event, helper) { 
       var getColumn = component.get("c.getColumnDefinitions");
        getColumn.setParams({
        });
        getColumn.setCallback(this, function(response) {
            //hide spinner when response coming from server
            var state = response.getState();
            if (state === "SUCCESS") {
                var columnDefinitions = response.getReturnValue();
                component.set("v.gridColumns", columnDefinitions);
            } else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(getColumn);
    
        var trecid = component.get('v.recordId');
        if(trecid){
            helper.callToServer(
                component,
                "c.findHierarchyData",
                function(response) {
                    var expandedRows = [];
                    var apexResponse = response;
                    var roles = {};
                    console.log('*******apexResponse:'+JSON.stringify(apexResponse));
                    var results = apexResponse;
                    roles[undefined] = { Name: "Root", _children: [] };
                    apexResponse.forEach(function(v) {
                        expandedRows.push(v.Id);
                        
                        if(v.Id===trecid)
                        {
                        roles[v.Id] = { 
                            Name: v.Name ,
                            trendIcon: 'standard:task2',
                            name: v.Id,
                            Email__c:v.Email__c,
                            Phone__c:v.Phone__c,
                            _children: [] };
                        }else
                        {
                             roles[v.Id] = { 
                            Name: v.Name ,
                            name: v.Id,
                            Email__c:v.Email__c,
                                 Phone__c:v.Phone__c,
                            _children: [] };
                        }
                       
                    });
                   
                    apexResponse.forEach(function(v) {
                        roles[v.PR__C]._children.push(roles[v.Id]);
                    });                
                    console.log('grid :'+ JSON.stringify(roles));
                    component.set("v.gridData", roles[undefined]._children);
                    component.set('v.gridExpandedRows', expandedRows);
                }, 
                {
                    recId: component.get('v.recordId')
                }
            );    
        }
    },
      
 // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
    
})