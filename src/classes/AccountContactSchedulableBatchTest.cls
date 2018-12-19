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