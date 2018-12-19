/**
 * Created by Igor Litvinyuk on 10.12.2018.
 */

public class AccountContactController {

    @AuraEnabled
    public static List<AccountContact__c> getAllAccountContacts() {
        return [
                SELECT
                        Name
                        , Account__r.Name
                        , Contact__r.Name
                        , isPrimary__c
                        , Active_Days__c
                        , CreatedDate
                FROM AccountContact__c
                ORDER BY CreatedDate
        ];
    }

    @AuraEnabled
    public static Integer deleteSpecificAccountContacts(Boolean isPrimaryTrue, Boolean isPrimaryFalse, Boolean all, Id[] ids) {
        Set<AccountContact__c> accountContacts = new Set<AccountContact__c>();
        if (all) {
            accountContacts.addAll(getAllAccountContacts());
        } else {
            if (isPrimaryTrue) {
                accountContacts.addAll(getSpecificAccountContacts(true));
            } if (isPrimaryFalse) {
                accountContacts.addAll(getSpecificAccountContacts(false));
            } if (!ids.isEmpty()) {
                accountContacts.addAll(getSpecificAccountContacts('Account__c', ids));
                accountContacts.addAll(getSpecificAccountContacts('Contact__c', ids));
            }
        }
        List<AccountContact__c> accountContactsForDelete = new List<AccountContact__c>(accountContacts);
        delete accountContactsForDelete;
        return accountContactsForDelete.size();
    }

    private static List<AccountContact__c> getSpecificAccountContacts(Boolean isPrimary) {
        return [
                SELECT Id
                FROM AccountContact__c
                WHERE isPrimary__c = :isPrimary
        ];
    }

    private static List<AccountContact__c> getSpecificAccountContacts(String sObjectType, Id[] ids) {
        return Database.query('SELECT Id FROM AccountContact__c WHERE ' +  sObjectType + ' IN :ids');
    }
}