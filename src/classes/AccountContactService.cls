/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

public class AccountContactService {

    public Map<Id, List<AccountContact__c>> getAccountContactsListByContactIdMap(List<AccountContact__c> accountContacts) {
        Map<Id, List<AccountContact__c>> resultMap = new Map<Id, List<AccountContact__c>>();
        for (AccountContact__c accountContact : accountContacts) {
            if (!resultMap.containsKey(accountContact.Contact__c)) {
                resultMap.put(accountContact.Contact__c, new List<AccountContact__c>());
            }
            List<AccountContact__c> accountContactsList = resultMap.get(accountContact.Contact__c);
            accountContactsList.add(accountContact);
        }
        return resultMap;
    }

    public Set<Id> getContactsIds(List<AccountContact__c> accountContacts, Boolean isPrimary) {
        Set<Id> result = new Set<Id>();
        for (AccountContact__c accountContact : accountContacts) {
            if (accountContact.isPrimary__c == isPrimary) {
                result.add(accountContact.Contact__c);
            }
        }
        return result;
    }

    public void changeIsPrimaryField(List<AccountContact__c> accountContacts, Boolean isPrimary) {
        for (AccountContact__c accountContact : accountContacts) {
            accountContact.isPrimary__c = isPrimary;
        }
    }

    public void setIsPrimaryFieldToTrue(Map<Id, List<AccountContact__c>> accountContactsListByContactIdMap, Map<Id, List<AccountContact__c>> existsAccountContactsListByContactIdMap) {
        for (Id contactId : accountContactsListByContactIdMap.keySet()) {
            if (existsAccountContactsListByContactIdMap.get(contactId) == null) {
                accountContactsListByContactIdMap.get(contactId)[0].isPrimary__c = true;
            }
        }
    }

    public List<AccountContact__c> receiveAccountContacts(Map<Id, List<AccountContact__c>> accountContactsListByContactIdMap) {
        List<AccountContact__c> result = new List<AccountContact__c>();
        for (Id contactId : accountContactsListByContactIdMap.keySet()) {
            result.add(accountContactsListByContactIdMap.get(contactId)[0]);
        }
        return result;
    }

    public Set<Id> getNecessaryContactsIds(List<AccountContact__c> accountContacts) {
        Set<Id> result = new Set<Id>();
        for (AccountContact__c accountContact : accountContacts) {
            result.add(accountContact.Contact__c);
        }
        return result;
    }

    public Set<Id> getContactsIdsWithTrueParents(List<AccountContact__c> accountContacts) {
        Set<Id> result = new Set<Id>();
        for (AccountContact__c accountContact : accountContacts) {
            if (accountContact.isPrimary__c) {
                result.add(accountContact.Contact__c);
            }
        }
        return result;
    }

    public void changeIsPrimaryFieldOnSpecificAccountContact(Map<Id, AccountContact__c> accountContactsByContactsIds, Set<Id> contactsIds) {
        for (Id contactId : accountContactsByContactsIds.keySet()) {
            if (!contactsIds.contains(contactId)) {
                accountContactsByContactsIds.get(contactId).isPrimary__c = true;
            } else {
                accountContactsByContactsIds.get(contactId).isPrimary__c = false;
            }
        }
    }

    public void setIsPrimaryFieldToTrueOnSingleAccountContact(Map<Id, AccountContact__c> accountContactsByContactsIds, Map<Id, List<AccountContact__c>> accountContactsListByContactsIds) {
        for (Id contactId : accountContactsByContactsIds.keySet()) {
            if (accountContactsListByContactsIds.get(contactId).size() == 1) {
                accountContactsByContactsIds.get(contactId).isPrimary__c = true;
            }
        }
    }

    public void removeNecessaryContactsIds(Set<Id> contactsIds, Map<Id, AccountContact__c> oldAccountContactsByContactsIds) {
        for (Id contactId : contactsIds) {
            if (oldAccountContactsByContactsIds.containsKey(contactId)) {
                oldAccountContactsByContactsIds.remove(contactId);
            }
        }
    }

    public void changeIsPrimaryFieldToTrueAndAddToUpdateList(Map<Id, List<AccountContact__c>> accountContactsListByContactsIds, Set<Id> contactsIds, List<AccountContact__c> accountContactsForUpdate) {
        for (Id contactId : accountContactsListByContactsIds.keySet()) {
            if (!contactsIds.contains(contactId)) {
                accountContactsListByContactsIds.get(contactId)[0].isPrimary__c = true;
                accountContactsForUpdate.add(accountContactsListByContactsIds.get(contactId)[0]);
            }
        }
    }

    public void changeIsPrimaryFieldToFalseAndAddToUpdateList(List<AccountContact__c> accountContacts, List<AccountContact__c> accountContactsForUpdate) {
        for (AccountContact__c accountContact : accountContacts) {
            accountContact.isPrimary__c = false;
            accountContactsForUpdate.add(accountContact);
        }
    }

    public void addSpecificAccountContactsToUpdateList(Map<Id, List<AccountContact__c>> oldAccountContactsListByContactsIds, Set<Id> contactsIdsWithTrue, List<AccountContact__c> accountContactsForUpdate){
        for (Id contactId : oldAccountContactsListByContactsIds.keySet()) {
            if (!contactsIdsWithTrue.contains(contactId) && oldAccountContactsListByContactsIds.get(contactId) != null) {
                if (!accountContactsForUpdate.contains(oldAccountContactsListByContactsIds.get(contactId)[0])) {
                    oldAccountContactsListByContactsIds.get(contactId)[0].isPrimary__c = true;
                    accountContactsForUpdate.add(oldAccountContactsListByContactsIds.get(contactId)[0]);
                }
            }
        }
    }

    public void distributeAccountContactsBeforeUpdate(List<AccountContact__c> oldAccountContacts, List<AccountContact__c> newAccountContacts
            , Set<Id> contactsIdsTrue, Map<Id, AccountContact__c> accountContactsByContactsIds, Map<Id, AccountContact__c> oldAccountContactsByContactsIds) {
        for (Integer i = 0; i < newAccountContacts.size(); i++) {
            Id newContactId = newAccountContacts[i].Contact__c;
            Id oldContactId = oldAccountContacts[i].Contact__c;
            if (oldContactId != newContactId) {
                if (!accountContactsByContactsIds.containsKey(newContactId)) {
                    accountContactsByContactsIds.put(newContactId, newAccountContacts[i]);
                } else {
                    newAccountContacts[i].isPrimary__c = false;
                }
            } else if (!oldAccountContacts[i].isPrimary__c && newAccountContacts[i].isPrimary__c && oldContactId == newContactId) {
                if (contactsIdsTrue.contains(newContactId)) {
                    newAccountContacts[i].isPrimary__c = false;
                }
                contactsIdsTrue.add(newContactId);
            } else if (oldAccountContacts[i].isPrimary__c && !newAccountContacts[i].isPrimary__c && oldContactId == newContactId) {
                oldAccountContactsByContactsIds.put(newContactId, newAccountContacts[i]);
            }
        }
    }

    public void distributeAccountContactsAfterUpdate(List<AccountContact__c> oldAccountContacts, List<AccountContact__c> newAccountContacts
            , Set<Id> contactsIds, Map<Id, AccountContact__c> accountContactsByContactsIds, Map<Id, AccountContact__c> oldAccountContactsByContactsIds) {
        for (Integer i = 0; i < newAccountContacts.size(); i++) {
            Id newContactId = newAccountContacts[i].Contact__c;
            Id oldContactId = oldAccountContacts[i].Contact__c;
            if (oldContactId != newContactId) {
                contactsIds.add(oldContactId);
            } else if (!oldAccountContacts[i].isPrimary__c && newAccountContacts[i].isPrimary__c && oldContactId == newContactId) {
                accountContactsByContactsIds.put(newContactId, newAccountContacts[i]);
            } else if (oldAccountContacts[i].isPrimary__c && !newAccountContacts[i].isPrimary__c && oldContactId == newContactId) {
                oldAccountContactsByContactsIds.put(newContactId, newAccountContacts[i]);
            }
        }
    }

    public List<AccountContact__c> getAccountContacts(Set<Id> contactsIds, Boolean isPrimary) {
        return [
                SELECT
                        isPrimary__c
                        , Contact__c
                FROM AccountContact__c
                WHERE Contact__c IN :contactsIds
                AND isPrimary__c = :isPrimary
                ORDER BY CreatedDate
        ];
    }

    public List<AccountContact__c> getAccountContactsWithCheckbox(Set<Id> contactsIds, List<AccountContact__c> accountContacts) {
        return [
                SELECT
                        Contact__c
                        , isPrimary__c
                FROM AccountContact__c
                WHERE Contact__c IN :contactsIds
                AND Id NOT IN :accountContacts
                AND isPrimary__c = TRUE
                ORDER BY CreatedDate
        ];
    }

    public List<AccountContact__c> getExistsAccountContacts(Set<Id> contactsIds) {
        return [
                SELECT
                        Contact__c
                        , isPrimary__c
                FROM AccountContact__c
                WHERE Contact__c IN :contactsIds
                ORDER BY CreatedDate
        ];
    }

    public List<AccountContact__c> getAccountContactsWithAnyCheckbox(Set<Id> contactsIds, List<AccountContact__c> accountContacts){
        return [
                SELECT
                        Contact__c
                        , isPrimary__c
                FROM AccountContact__c
                WHERE Contact__c IN :contactsIds
                AND Id NOT IN :accountContacts
                ORDER BY CreatedDate
        ];
    }

    public void deleteAccountContactsViaAccount(List<Account> accounts) {
        delete [
                SELECT Id
                FROM AccountContact__c
                WHERE Account__c IN :accounts
        ];
    }

    public void deleteAccountContactsViaContact(List<Contact> contacts) {
        delete [
                SELECT Id
                FROM AccountContact__c
                WHERE Contact__c IN :contacts
        ];
    }
}