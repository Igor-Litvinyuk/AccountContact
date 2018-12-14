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
       helper.deleteAccountContacts(component);
    }
});