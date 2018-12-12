/**
 * Created by Igor Litvinyuk on 11.12.2018.
 */
({
    onCheckTrue: function (component, event, helper) {
        let value = component.find("checkboxTrue").get("v.value");
        component.set("v.isPrimaryTrue", !!value);
    },

    onCheckFalse: function (component, event, helper) {
        let value = component.find("checkboxFalse").get("v.value");
        component.set("v.isPrimaryFalse", !!value);
    },

    onCheckAll: function (component, event, helper) {
        let value = component.find("checkboxAll").get("v.value");
        component.set("v.all", !!value);
    },

    onDelete: function (component, event, helper) {
        let isPrimaryTrue = component.get("v.isPrimaryTrue");
        let isPrimaryFalse = component.get("v.isPrimaryFalse");
        let all = component.get("v.all");
        let action = component.get("c.deleteSpecificAccountContacts");
        action.setParams({
            "isPrimaryTrue" : isPrimaryTrue,
            "isPrimaryFalse" : isPrimaryFalse,
            "all" : all
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.find('notifLib').showNotice({
                    "variant": "success",
                    "header": "Successful!",
                    "message": "AccountContacts were deleted!",
                });
                $A.get('e.force:refreshView').fire();
                component.find("overlayLib").notifyClose();
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
});