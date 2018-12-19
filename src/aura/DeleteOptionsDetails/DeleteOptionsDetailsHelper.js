/**
 * Created by Igor Litvinyuk on 14.12.2018.
 */
({
    deleteAccountContacts: function (component) {
        let action = component.get("c.deleteSpecificAccountContacts");
        action.setParams({
            isPrimaryTrue: component.get("v.isPrimaryTrue"),
            isPrimaryFalse: component.get("v.isPrimaryFalse"),
            all: component.get("v.all"),
            ids: this.getSObjectsIds(component)
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let count = response.getReturnValue();
                if (count !== 0) {
                    this.showInfoMessage(component, count + " AccountContacts deleted!");
                    $A.get("e.force:refreshView").fire();
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
        component.find("notifyLib").showNotice({
            variant: 'info',
            header: 'Success!',
            message: message
        });
    },

    showWarningMessage: function (component, message) {
        component.find("notifyLib").showNotice({
            variant: 'warning',
            header: 'Warning!',
            message: message
        });
    },

    getSObjectsIds: function (component) {
        let selection = component.get("v.sObjects");
        return selection.map(element => element.id);
    },
});