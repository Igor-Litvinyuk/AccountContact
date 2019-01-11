/**
 * Created by Igor Litvinyuk on 11.01.2019.
 */

@isTest
private class SampleLookupControllerTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.insertTestData(200);
    }

    @isTest
    static void testSearchAccountsAndContacts() {
        Id [] fixedResults = new Id[2];
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        fixedResults.add(accountId);
        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        fixedResults.add(contactId);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();
        Test.startTest();
        List<LookupSearchResult> results = SampleLookupController.search('Test', new List<String>{});
        Test.stopTest();
        System.assertEquals(2, results.size());
    }
}