/**
 * Created by Igor Litvinyuk on 10.12.2018.
 */
({
    doInit: function (component, event, helper) {
        let action = component.get("c.getAllAccountContacts");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountContacts", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
});