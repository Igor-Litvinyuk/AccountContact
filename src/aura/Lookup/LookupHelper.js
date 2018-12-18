/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */
({
    toggleSearchSpinner: function (component) {
        let spinner = component.find("spinner");
        let searchIcon = component.find("search-icon");
        $A.util.toggleClass(spinner, "slds-hide");
        $A.util.toggleClass(searchIcon, "slds-hide");
    },

    getSelectedIds: function (component) {
        let selection = component.get("v.selection");
        return selection.map(element => element.id);
    },

    isSelectionAllowed: function (component) {
        return component.get("v.isMultiEntry") || component.get("v.selection").length === 0;
    },

    updateSearchTerm: function (component, searchTerm) {
        // Cleanup new search term
        let updatedSearchTerm = searchTerm.trim().replace(/\*/g).toLowerCase();
        // Compare clean new search term with current one and abort if identical
        let currentSearchTerm = component.get("v.searchTerm");
        if (currentSearchTerm === updatedSearchTerm) {
            return;
        }
        // Update search term
        component.set("v.searchTerm", updatedSearchTerm);
        // Ignore search terms that are too small
        if (updatedSearchTerm.length < 2) {
            component.set("v.searchResults", []);
            return;
        }
        // Apply search throttling (prevents search if user is still typing)
        let searchTimeout = component.get("v.searchThrottlingTimeout");
        if (searchTimeout) {
            clearTimeout(searchTimeout);
        }
        searchTimeout = window.setTimeout(
            $A.getCallback(() => {
                // Send search event if it long
                let searchTerm = component.get("v.searchTerm");
                if (searchTerm.length >= 2) {
                    let searchEvent = component.getEvent("onSearch");
                    searchEvent.fire();
                }
                component.set("v.searchThrottlingTimeout", null);
            }),
            300
        );
        component.set("v.searchThrottlingTimeout", searchTimeout);
    },

    selectResult: function (component, recordId) {
        // Save selection
        let searchResults = component.get("v.searchResults");
        let selectedResult = searchResults.filter(result => result.id === recordId);
        if (selectedResult.length > 0) {
            let selection = component.get("v.selection");
            selection.push(selectedResult[0]);
            component.set("v.selection", selection);
        }
        // Reset search
        let searchInput = component.find("searchInput");
        searchInput.getElement().value = '';
        component.set("v.searchTerm", '');
        component.set("v.searchResults", []);
    },

    removeSelectedItem: function (component, removedItemId) {
        let selection = component.get("v.selection");
        let updatedSelection = selection.filter(item => item.id !== removedItemId);
        component.set("v.selection", updatedSelection);
    }
});