/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

trigger AccountContactTrigger on AccountContact__c (before insert, before update, after update, after delete) {

    AccountContactHandler handler = new AccountContactHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            if (AccountContactHandler.isFirstRun) {
                handler.onBeforeUpdate(Trigger.old, Trigger.new);
            }
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            if (AccountContactHandler.isFirstRun) {
                AccountContactHandler.isFirstRun = false;
                handler.onAfterUpdate(Trigger.old, Trigger.new);
            }
        } else if (Trigger.isDelete) {
            handler.onAfterDelete(Trigger.old);
        }
    }
}