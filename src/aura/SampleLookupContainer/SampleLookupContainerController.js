/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */
({
    lookupSearch: function (component, event, helper) {
        // Get the SampleLookupController.search server side action and passes the action to the Lookup component by calling the search method
        let action = component.get("c.search");
        component.find("lookup").search(action);
    },

    onSubmit: function (component, event, helper) {

    }
});