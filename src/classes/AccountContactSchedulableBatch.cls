/**
 * Created by Igor Litvinyuk on 14.12.2018.
 */

public class AccountContactSchedulableBatch implements Database.Batchable<sObject>, Schedulable {

    private String fieldName;
    private Integer increment;

    public AccountContactSchedulableBatch(String fieldName, Integer increment) {
        this.fieldName = fieldName;
        this.increment = increment;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT ' + fieldName + ' FROM AccountContact__c WHERE isPrimary__c = true');
    }

    public void execute(Database.BatchableContext bc, List<AccountContact__c> scope) {
        for (AccountContact__c accountContact : scope) {
            accountContact.put(fieldName, (Decimal) accountContact.get(fieldName) + increment);
        }
        update scope;
    }
    public void finish(Database.BatchableContext bc) {
    }

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new AccountContactSchedulableBatch(fieldName, increment));
    }

    public static void start(Schema.SObjectField field, Integer increment, String jobName) {
        if (field.getDescribe().getType() == DisplayType.DOUBLE) {
            String fieldName = field.getDescribe().getName();
            switch on fieldName {
                when 'Active_Days__c' {
                    String sch = '0 0 8 * * ?';
                    System.schedule(jobName, sch, new AccountContactSchedulableBatch(fieldName, increment));
                }
                //There will be another one
            }
        }
    }
}