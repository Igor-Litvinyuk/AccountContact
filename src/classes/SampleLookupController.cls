/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */

public with sharing class SampleLookupController {

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        searchTerm += '*';
        List<List<SObject>> searchResults = [
                FIND :searchTerm
                IN ALL FIELDS
                        RETURNING
                        Account (Id, Name
                                WHERE Id NOT IN :selectedIds),
                        Contact (Id, FirstName, LastName
                                WHERE Id NOT IN :selectedIds)
                LIMIT :MAX_RESULTS
        ];

        List<LookupSearchResult> results = new List<LookupSearchResult>();
        // Extract Accounts and Contacts & convert them into LookupSearchResult
        Account [] accounts = ((List<Account>) searchResults[0]);
        for (Account account : accounts) {
            results.add(new LookupSearchResult(account.Id, 'Account', 'standard:account', account.Name));
        }
        Contact [] contacts = ((List<Contact>) searchResults[1]);
        for (Contact contact : contacts) {
            results.add(new LookupSearchResult(contact.Id, 'Contact', 'standard:contact', contact.FirstName + ' ' + contact.LastName));
        }
        return results;
    }
}