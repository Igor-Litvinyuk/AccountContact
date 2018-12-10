/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

public class TestDataFactory {

    public static List<Account> constructAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account account = new Account(Name = 'Test Account ' + i);
            accounts.add(account);
        }
        return accounts;
    }

    public static List<Contact> constructContacts(Integer count) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            Contact contact = new Contact(LastName = 'Test Contact ' + i);
            contacts.add(contact);
        }
        return contacts;
    }

    public static List<AccountContact__c> constructAccountContacts(Integer count, Boolean isPrimary) {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<AccountContact__c> accountContacts = new List<AccountContact__c>();
        for (Integer i = 0; i < count; i++) {
            AccountContact__c accountContact = new AccountContact__c(
                    Account__c = accounts[i].Id,
                    Contact__c = contacts[i].Id,
                    isPrimary__c = isPrimary
            );
            accountContacts.add(accountContact);
        }
        return accountContacts;
    }

    public static void insertTestData(Integer count) {
        List<Account> accounts = constructAccounts(count);
        insert accounts;
        List<Contact> contacts = constructContacts(count);
        insert contacts;
    }
}