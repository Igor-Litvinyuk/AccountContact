/**
 * Created by Igor Litvinyuk on 10.12.2018.
 */
({
    doInit: function (component, event, helper) {
        helper.getAllAccountContacts(component);
    },

    onSendEmail: function (component, event, helper) {
        component.find("navService").navigate({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.id,
                actionName: 'view',
                objectApiName: 'AccountContact__c'
            },
            state: {
                action: 'send-email'
            }
        });
    }
});