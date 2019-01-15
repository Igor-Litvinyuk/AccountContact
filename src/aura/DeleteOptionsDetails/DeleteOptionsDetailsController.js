/**
 * Created by Igor Litvinyuk on 11.12.2018.
 */
({
    handleSubmitButtonEvent: function (component, event, helper) {
        let sObjects = event.getParam("sObjects");
        component.set("v.sObjects", sObjects);
    },

    onDelete: function (component, event, helper) {
        if (confirm("Are you sure? " + String.fromCodePoint(0x1F628))) {
            helper.deleteAccountContacts(component);
        }
    }
});