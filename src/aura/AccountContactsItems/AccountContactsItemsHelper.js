/**
 * Created by Igor Litvinyuk on 14.12.2018.
 */
({
    getAllAccountContacts: function (component) {
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