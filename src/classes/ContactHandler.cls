/**
 * Created by Igor Litvinyuk on 28.11.2018.
 */

public class ContactHandler {

    AccountContactService service = new AccountContactService();

    public void onBeforeDelete(List<Contact> oldContacts) {
        service.deleteAccountContactsViaContact(oldContacts);
    }
}