/**
 * Created by Igor Litvinyuk on 17.12.2018.
 */

public class LookupSearchResult {

    @AuraEnabled
    private Id id {get; set;}
    @AuraEnabled
    private String sObjectType {get; set;}
    @AuraEnabled
    private String icon {get; set;}
    @AuraEnabled
    private String title {get; set;}

    public LookupSearchResult(Id id, String sObjectType, String icon, String title) {
        this.id = id;
        this.sObjectType = sObjectType;
        this.icon = icon;
        this.title = title;
    }
}