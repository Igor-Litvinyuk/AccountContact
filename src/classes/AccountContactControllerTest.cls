/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */

@isTest
private class AccountContactControllerTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.insertTestData(200);
    }

    @isTest
    static void testGetAllAccountContacts() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, true);
        insert accountContacts;
        Test.startTest();
        List<AccountContact__c> accountContactsList = AccountContactController.getAllAccountContacts();
        Test.stopTest();
        Integer verifyAccountContacts = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(200, verifyAccountContacts);
    }

    @isTest
    static void testDeleteSpecificAccountContacts() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, true);
        insert accountContacts;
        Test.startTest();
        Integer count = AccountContactController.deleteSpecificAccountContacts(true, true, false, new String[]{});
        Test.stopTest();
        Integer verifyAccountContacts = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(count, accountContacts.size());
        System.assertEquals(0, verifyAccountContacts);
    }

    @isTest
    static void testDeleteAllAccountContacts() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, true);
        insert accountContacts;
        Test.startTest();
        Integer count = AccountContactController.deleteSpecificAccountContacts(false, false, true, new String[]{});
        Test.stopTest();
        Integer verifyAccountContacts = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(count, accountContacts.size());
        System.assertEquals(0, verifyAccountContacts);
    }

    @isTest
    static void testDeleteAccountContactsWithRelatedObjects() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, true);
        insert accountContacts;
        Test.startTest();
        Integer count = AccountContactController.deleteSpecificAccountContacts(false, false, true, new String[]{});
        Test.stopTest();
        Integer verifyAccountContacts = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(count, accountContacts.size());
        System.assertEquals(0, verifyAccountContacts);
    }

    @isTest
    static void testGetSpecificAccountContacts() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, true);
        insert accountContacts;
        String[] ids = new String[]{};
        List<Account> accounts = [SELECT Id FROM Account ORDER BY Name LIMIT 100];
        List<Contact> contacts = [SELECT Id FROM Contact ORDER BY Name DESC LIMIT 100];
        for (Account account: accounts){
            ids.add(account.Id);
        }
        for (Contact contact: contacts){
            ids.add(contact.Id);
        }
        Test.startTest();
        Integer count = AccountContactController.deleteSpecificAccountContacts(false, false, false, ids);
        Test.stopTest();
        Integer verifyAccountContacts = [SELECT COUNT() FROM AccountContact__c];
        System.assertEquals(0, verifyAccountContacts);
    }
}