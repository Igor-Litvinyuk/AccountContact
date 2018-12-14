/**
 * Created by Igor Litvinyuk on 10.12.2018.
 */
({
    handleShowModal: function (component, event, helper) {
        let modalBody;
        $A.createComponent("c:DeleteOptionsDetails", null,
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        header: "Delete Options",
                        body: modalBody,
                        showCloseButton: true
                    })
                }
            });
    }
});