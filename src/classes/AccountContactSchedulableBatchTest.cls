/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */

@isTest
private class AccountContactSchedulableBatchTest {

    private static String CRON_EXP = '0 0 8 * * ?';
    private static Schema.SObjectField activeDaysField = AccountContact__c.Active_Days__c;
    private static final Integer activeDaysIncrement = 1;

    @TestSetup
    static void setupTestData() {
        TestDataFactory.insertTestData(200);
    }

    @isTest
    static void testUpdateActiveDaysOnceADay() {
        List<AccountContact__c> accountContacts = TestDataFactory.constructAccountContacts(200, true);
        insert accountContacts;
        Test.startTest();
        String fieldName = activeDaysField.getDescribe().getName();
        AccountContactSchedulableBatch accountContactSchedulableBatch = new AccountContactSchedulableBatch(fieldName, activeDaysIncrement);
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, accountContactSchedulableBatch);
        accountContactSchedulableBatch.execute(null);
        Test.stopTest();
        List<AccountContact__c> verifyAccountContacts = [SELECT Active_Days__c FROM AccountContact__c];
        for (AccountContact__c accountContact : verifyAccountContacts) {
            System.assertEquals(activeDaysIncrement, accountContact.Active_Days__c);
        }
    }

    @isTest
    static void testStartMethod() {
        Test.startTest();
        AccountContactSchedulableBatch.start(activeDaysField, activeDaysIncrement, 'ActiveDaysUpdatingTest');
        Test.stopTest();
    }
}

//@isTest
//private class AccountContactSchedulableBatchTest {
//
//private static String CRON_EXP = '0 0 8 * * ?';
//private static Schema.SObjectField activeDaysField = AccountContact__c.Active_Days__c;
//private static final Integer activeDaysIncrement = 1;
//
//@testSetup
//static void setup() {
//Account account = new Account(Name = 'Test');
//insert account;
//Contact contact = new Contact(LastName = 'Test');
//insert contact;
//Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
//Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
//AccountContact__c accountContact = new AccountContact__c();
//accountContact.Account__c = accountId;
//accountContact.Contact__c = contactId;
//accountContact.isPrimary__c = true;
//accountContact.Active_Days__c = 0;
//insert accountContact;
//}
//
//@isTest
//static void testUpdateActiveDaysOnceADay() {
//Test.startTest();
//String fieldName = activeDaysField.getDescribe().getName();
//AccountContactSchedulableBatch accountContactSchedulableBatch = new AccountContactSchedulableBatch(fieldName, activeDaysIncrement);
//String jobId = System.schedule('ScheduledApexTest', CRON_EXP, accountContactSchedulableBatch);
//accountContactSchedulableBatch.execute(null);
//Test.stopTest();
//AccountContact__c verifyAccountContact = [SELECT Active_Days__c FROM AccountContact__c LIMIT 1];
//System.assertEquals(activeDaysIncrement, verifyAccountContact.Active_Days__c);
//}
//
//@isTest
//static void testStartMethod() {
//Test.startTest();
//AccountContactSchedulableBatch.start(activeDaysField, activeDaysIncrement, 'ActiveDaysUpdatingTest');
//Test.stopTest();
//}
//}