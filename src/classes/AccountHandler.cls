/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

public class AccountHandler {

    AccountContactService service = new AccountContactService();

    public void onBeforeDelete(List<Account> oldAccounts){
        service.deleteAccountContactsViaAccount(oldAccounts);
    }
}