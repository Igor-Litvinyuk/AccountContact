/**
 * Created by Igor Litvinyuk on 11.12.2018.
 */
({
    onDelete: function (component, event, helper) {
        if (confirm("Are you sure?")){
            helper.deleteAccountContacts(component);
        }
    }
});