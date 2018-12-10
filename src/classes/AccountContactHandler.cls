/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

public class AccountContactHandler {

    AccountContactService service = new AccountContactService();
    public static Boolean isFirstRun = true;

    public void onBeforeInsert(List<AccountContact__c> newAccountContacts) {
        service.changeIsPrimaryField(newAccountContacts, false);
        Map<Id, List<AccountContact__c>> accountContactsListByContactsIds = service.getAccountContactsListByContactIdMap(newAccountContacts);
        List<AccountContact__c> accountContactsWithNecessaryContacts = service.getAccountContacts(accountContactsListByContactsIds.keySet(), true);
        Map<Id, List<AccountContact__c>> existsAccountContactsListByContactsIds = service.getAccountContactsListByContactIdMap(accountContactsWithNecessaryContacts);
        service.setIsPrimaryFieldToTrue(accountContactsListByContactsIds, existsAccountContactsListByContactsIds);
    }

    public void onBeforeUpdate(List<AccountContact__c> oldAccountContacts, List<AccountContact__c> newAccountContacts) {
        Set<Id> contactsIdsTrue = new Set<Id>();
        Map<Id, AccountContact__c> accountContactsByContactsIds = new Map<Id, AccountContact__c>();
        Map<Id, AccountContact__c> oldAccountContactsByContactsIds = new Map<Id, AccountContact__c>();
        service.distributeAccountContactsBeforeUpdate(oldAccountContacts, newAccountContacts, contactsIdsTrue, accountContactsByContactsIds, oldAccountContactsByContactsIds);
        List<AccountContact__c> accountContactsWithCheckbox = service.getAccountContactsWithCheckbox(accountContactsByContactsIds.keySet(), accountContactsByContactsIds.values());
        Set<Id> contactsIds = service.getNecessaryContactsIds(accountContactsWithCheckbox);
        service.changeIsPrimaryFieldOnSpecificAccountContact(accountContactsByContactsIds, contactsIds);
        List<AccountContact__c> existsAccountContacts = service.getExistsAccountContacts(oldAccountContactsByContactsIds.keySet());
        Map<Id, List<AccountContact__c>> accountContactsListByContactsIds = service.getAccountContactsListByContactIdMap(existsAccountContacts);
        service.setIsPrimaryFieldToTrueOnSingleAccountContact(oldAccountContactsByContactsIds, accountContactsListByContactsIds);
    }

    public void onAfterUpdate(List<AccountContact__c> oldAccountContacts, List<AccountContact__c> newAccountContacts) {
        List<AccountContact__c> accountContactsForUpdate = new List<AccountContact__c>();
        Set<Id> contactsIds = new Set<Id>();
        Map<Id, AccountContact__c> accountContactsByContactsIds = new Map<Id, AccountContact__c>();
        Map<Id, AccountContact__c> oldAccountContactsByContactsIds = new Map<Id, AccountContact__c>();
        service.distributeAccountContactsAfterUpdate(oldAccountContacts, newAccountContacts, contactsIds, accountContactsByContactsIds, oldAccountContactsByContactsIds);
        service.removeNecessaryContactsIds(contactsIds, oldAccountContactsByContactsIds);
        List<AccountContact__c> existsAccountContacts = service.getExistsAccountContacts(contactsIds);
        Set<Id> contactsIdsTrue = service.getContactsIdsWithTrueParents(existsAccountContacts);
        Map<Id, List<AccountContact__c>> accountContactsListByContactsIds = service.getAccountContactsListByContactIdMap(existsAccountContacts);
        service.changeIsPrimaryFieldToTrueAndAddToUpdateList(accountContactsListByContactsIds, contactsIdsTrue, accountContactsForUpdate);
        List<AccountContact__c> accountContactsWithCheckbox = service.getAccountContactsWithCheckbox(accountContactsByContactsIds.keySet(), accountContactsByContactsIds.values());
        service.changeIsPrimaryFieldToFalseAndAddToUpdateList(accountContactsWithCheckbox, accountContactsForUpdate);
        List<AccountContact__c> accountContactsFalse = service.getAccountContactsWithAnyCheckbox(oldAccountContactsByContactsIds.keySet(), oldAccountContactsByContactsIds.values());
        Set<Id> contactsIdsWithTrue = service.getContactsIdsWithTrueParents(accountContactsFalse);
        Map<Id, List<AccountContact__c>> oldAccountContactsListByContactsIds = service.getAccountContactsListByContactIdMap(accountContactsFalse);
        service.addSpecificAccountContactsToUpdateList(oldAccountContactsListByContactsIds, contactsIdsWithTrue, accountContactsForUpdate);
        update accountContactsForUpdate;
    }

    public void onAfterDelete(List<AccountContact__c> oldAccountContacts) {
        Set<Id> contactIds = service.getContactsIds(oldAccountContacts, true);
        List<AccountContact__c> accountContacts = service.getAccountContacts(contactIds, false);
        Map<Id, List<AccountContact__c>> existsAccountContactsListByContactsIds = service.getAccountContactsListByContactIdMap(accountContacts);
        List<AccountContact__c> accountContactsForUpdate = service.receiveAccountContacts(existsAccountContactsListByContactsIds);
        service.changeIsPrimaryField(accountContactsForUpdate, true);
        update accountContactsForUpdate;
    }
}