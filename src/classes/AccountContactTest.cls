/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

@isTest
private class AccountContactTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.insertTestData(200);
    }

    @isTest
    static void testCreateAccountContacts() {
        List<AccountContact__c> accountContacts1 = TestDataFactory.constructAccountContacts(200, false);
        List<AccountContact__c> accountContacts2 = TestDataFactory.constructAccountContacts(200, true);
        Test.startTest();
        insert accountContacts1;
        insert accountContacts2;
        Test.stopTest();
        List<AccountContact__c> verifyAccountContacts = [SELECT isPrimary__c FROM AccountContact__c WHERE isPrimary__c = TRUE];
        System.assertEquals(200, verifyAccountContacts.size());
    }

    @isTest
    static void testDeleteAccountContacts() {
        List<AccountContact__c> accountContacts1 = TestDataFactory.constructAccountContacts(200, false);
        List<AccountContact__c> accountContacts2 = TestDataFactory.constructAccountContacts(200, false);
        Test.startTest();
        insert accountContacts1;
        insert accountContacts2;
        delete [SELECT Id FROM AccountContact__c WHERE isPrimary__c = TRUE];
        Test.stopTest();
        List<AccountContact__c> verifyAccountContacts = [SELECT isPrimary__c FROM AccountContact__c WHERE isPrimary__c = TRUE];
        System.assertEquals(200, verifyAccountContacts.size());
    }

    @isTest
    static void testDeleteAccounts() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, false);
        Test.startTest();
        insert accountContacts;
        delete [SELECT Id FROM Account];
        Test.stopTest();
        Integer verifyAccountContactsCount = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(0, verifyAccountContactsCount);
    }

    @isTest
    static void testDeleteContacts() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, false);
        Test.startTest();
        insert accountContacts;
        delete [SELECT Id FROM Contact];
        Test.stopTest();
        Integer verifyAccountContactsCount = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(0, verifyAccountContactsCount);
    }

    @isTest
    static void testUpdateIsPrimaryFieldOnAccountContacts(){
        List<Account> accounts = [SELECT Id FROM Account LIMIT 20];
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 5];
        List<AccountContact__c> accountContactsForInsert = new List<AccountContact__c>();
        for (Integer i = 0; i < 10; i++) {
            AccountContact__c accountContact = new AccountContact__c();
            accountContact.Account__c = accounts[i].Id;
            accountContact.Contact__c = i < 5 ? contacts[0].Id : contacts[1].Id;
            accountContactsForInsert.add(accountContact);
        }
        for (Integer i = 0; i < 10; i++) {
            AccountContact__c accountContact = new AccountContact__c();
            accountContact.Account__c = accounts[i].Id;
            accountContact.Contact__c = i < 5 ? contacts[2].Id : contacts[3].Id;
            accountContactsForInsert.add(accountContact);
        }
        AccountContact__c accountContact = new AccountContact__c(Account__c = accounts[0].Id, Contact__c = contacts[4].Id);
        accountContactsForInsert.add(accountContact);
        insert accountContactsForInsert;
        List<AccountContact__c> insertedAccountContacts = [SELECT Contact__c, isPrimary__c FROM AccountContact__c ORDER BY CreatedDate];
        List<AccountContact__c> accountContactsForUpdate = new List<AccountContact__c>();
        //Check AccountContact
        insertedAccountContacts[1].isPrimary__c = true;
        accountContactsForUpdate.add(insertedAccountContacts[1]);
        //Uncheck AccountContact
        insertedAccountContacts[5].isPrimary__c = false;
        accountContactsForUpdate.add(insertedAccountContacts[5]);
        //Check and Uncheck AccountContacts
        insertedAccountContacts[10].isPrimary__c = false;
        accountContactsForUpdate.add(insertedAccountContacts[10]);
        insertedAccountContacts[11].isPrimary__c = true;
        accountContactsForUpdate.add(insertedAccountContacts[11]);
        insertedAccountContacts[12].isPrimary__c = true;
        accountContactsForUpdate.add(insertedAccountContacts[12]);
        //Uncheck last single AccountContact
        insertedAccountContacts[20].isPrimary__c = false;
        accountContactsForUpdate.add(insertedAccountContacts[20]);
        Test.startTest();
        update accountContactsForUpdate;
        Test.stopTest();
        List<AccountContact__c> verifyAccountContacts = [SELECT Contact__c, isPrimary__c FROM AccountContact__c ORDER BY CreatedDate];
        //Check AccountContact
        System.assertEquals(false, verifyAccountContacts[0].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[1].isPrimary__c);
        //Uncheck AccountContact
        System.assertEquals(false, verifyAccountContacts[5].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[6].isPrimary__c);
        //Check few and uncheck AccountContacts
        System.assertEquals(false, verifyAccountContacts[10].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[11].isPrimary__c);
        System.assertEquals(false, verifyAccountContacts[12].isPrimary__c);
        //Uncheck last single AccountContact
        System.assertEquals(true, verifyAccountContacts[20].isPrimary__c);
    }

    @isTest
    static void testUpdateContactOnAccountContacts(){
        List<Account> accounts = [SELECT Id FROM Account LIMIT 20];
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 20];
        List<AccountContact__c> accountContactsForInsert = new List<AccountContact__c>();
        for (Integer i = 0; i < 10; i++) {
            AccountContact__c accountContact = new AccountContact__c();
            accountContact.Account__c = accounts[i].Id;
            accountContact.Contact__c = i < 5 ? contacts[0].Id : contacts[1].Id;
            accountContactsForInsert.add(accountContact);
        }
        for (Integer i = 0; i < 10; i++) {
            AccountContact__c accountContact = new AccountContact__c();
            accountContact.Account__c = accounts[i].Id;
            accountContact.Contact__c = i < 5 ? contacts[2].Id : contacts[3].Id;
            accountContactsForInsert.add(accountContact);
        }
        insert accountContactsForInsert;
        List<AccountContact__c> insertedAccountContacts = [SELECT Contact__c, isPrimary__c FROM AccountContact__c ORDER BY CreatedDate];
        List<AccountContact__c> accountContactsForUpdate = new List<AccountContact__c>();
        //Change different Contacts on AccountContacts
        insertedAccountContacts[0].Contact__c = contacts[1].Id;
        accountContactsForUpdate.add(insertedAccountContacts[0]);
        insertedAccountContacts[1].Contact__c = contacts[4].Id;
        accountContactsForUpdate.add(insertedAccountContacts[1]);
        insertedAccountContacts[2].Contact__c = contacts[4].Id;
        accountContactsForUpdate.add(insertedAccountContacts[2]);
        insertedAccountContacts[3].Contact__c = contacts[5].Id;
        accountContactsForUpdate.add(insertedAccountContacts[3]);
        //Change Contact and Uncheck AccountContact
        insertedAccountContacts[10].isPrimary__c = false;
        accountContactsForUpdate.add(insertedAccountContacts[10]);
        insertedAccountContacts[11].Contact__c = contacts[6].Id;
        accountContactsForUpdate.add(insertedAccountContacts[11]);

        Test.startTest();
        update accountContactsForUpdate;
        Test.stopTest();
        List<AccountContact__c> verifyAccountContacts = [SELECT Contact__c, isPrimary__c FROM AccountContact__c ORDER BY CreatedDate];
        //Change different Contacts on AccountContacts
        System.assertEquals(false, verifyAccountContacts[0].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[1].isPrimary__c);
        System.assertEquals(false, verifyAccountContacts[2].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[3].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[4].isPrimary__c);
        //Change Contact and Uncheck AccountContact
        System.assertEquals(true, verifyAccountContacts[10].isPrimary__c);
        System.assertEquals(true, verifyAccountContacts[11].isPrimary__c);
    }
}