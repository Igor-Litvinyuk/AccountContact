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
                        , CreatedDate
                FROM AccountContact__c
        ];
    }

    @AuraEnabled
    public static void deleteSpecificAccountContacts(Boolean isPrimaryTrue, Boolean isPrimaryFalse, Boolean all) {
        List<AccountContact__c> accountContacts = new List<AccountContact__c>();
        if (all) {
            accountContacts = getAllAccountContacts();
        } else if (isPrimaryTrue) {
            accountContacts = getSpecificAccountContacts(isPrimaryTrue);
        } else if (isPrimaryFalse){
            accountContacts = getSpecificAccountContacts(isPrimaryFalse);
        }
        delete accountContacts;
    }

    public static List<AccountContact__c> getSpecificAccountContacts(Boolean isPrimary) {
        return [
                SELECT Id
                FROM AccountContact__c
                WHERE isPrimary__c = :isPrimary
        ];
    }
}