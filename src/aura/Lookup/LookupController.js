/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */
({
    search: function (component, event, helper) {
        let action = event.getParam("arguments").serverAction;
        helper.toggleSearchSpinner(component);
        action.setParams({
            searchTerm: component.get("v.searchTerm"),
            selectedIds: helper.getSelectedIds(component)
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === "SUCCESS") {
                helper.toggleSearchSpinner(component);
                let returnValue = response.getReturnValue();
                component.set("v.searchResults", returnValue);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    onFocus: function (component, event, helper) {
        // Prevent action if selection is not allowed
        if (!helper.isSelectionAllowed(component)) {
            return;
        }
        component.set("v.hasFocus", true);
    },

    onBlur: function (component, event, helper) {
        // Prevent action if selection is not allowed
        if (!helper.isSelectionAllowed(component)) {
            return;
        }
        // Delay hiding combobox so that we can capture selected result
        let blurTimeout = window.setTimeout(
            $A.getCallback(() => {
                component.set("v.hasFocus", false);
                component.set("v.blurTimeout", null);
            }),
            300
        );
        component.set("v.blurTimeout", blurTimeout);
    },

    onInput: function (component, event, helper) {
        // Prevent action if selection is not allowed
        if (!helper.isSelectionAllowed(component)) {
            return;
        }
        let newSearchTerm = event.target.value;
        helper.updateSearchTerm(component, newSearchTerm);
    },

    onComboboxClick: function (component, event, helper) {
        // Hide combobox
        let blurTimeout = component.get("v.blurTimeout");
        if (blurTimeout) {
            clearTimeout(blurTimeout);
        }
        component.set("v.hasFocus", false);
    },

    onResultClick: function (component, event, helper) {
        let recordId = event.currentTarget.id;
        helper.selectResult(component, recordId);
        let clickEvent = component.getEvent("onSelection");
        if (clickEvent) {
            clickEvent.fire();
        }
    },

    onRemoveSelectedItem: function (component, event, helper) {
        let itemId = event.getSource().get("v.name");
        helper.removeSelectedItem(component, itemId);
    }
});