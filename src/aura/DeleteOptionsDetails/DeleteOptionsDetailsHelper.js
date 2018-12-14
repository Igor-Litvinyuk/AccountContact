/**
 * Created by Igor Litvinyuk on 14.12.2018.
 */
({
    deleteAccountContacts: function (component) {
        let isPrimaryTrue = component.get("v.isPrimaryTrue");
        let isPrimaryFalse = component.get("v.isPrimaryFalse");
        let all = component.get("v.all");
        let action = component.get("c.deleteSpecificAccountContacts");
        action.setParams({
            "isPrimaryTrue": isPrimaryTrue,
            "isPrimaryFalse": isPrimaryFalse,
            "all": all
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let count = response.getReturnValue();
                if (count !== 0) {
                    this.showInfoMessage(component, count + " AccountContacts deleted!");
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.showWarningMessage(component, " No data to delete!");
                }
                component.find("overlayLib").notifyClose();
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    showInfoMessage: function (component, message) {
        component.find('notifyLib').showNotice({
            "variant": "info",
            "header": "Success!",
            "message": message
        });
    },

    showWarningMessage: function (component, message) {
        component.find('notifyLib').showNotice({
            "variant": "warning",
            "header": "Warning!",
            "message": message
        });
    }
});