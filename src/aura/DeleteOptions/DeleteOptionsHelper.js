/**
 * Created by Igor Litvinyuk on 14.12.2018.
 */
({
    createModalComponent: function (component) {
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