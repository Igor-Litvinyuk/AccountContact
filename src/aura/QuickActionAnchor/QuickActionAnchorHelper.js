/**
 * Created by Igor Litvinyuk on 11.01.2019.
 */
({
    executeQuickAction: function (component) {
        const paramName = component.get("v.paramName");
        const paramValue = component.get("v.paramValue");
        const quickAction = component.get("v.quickAction");
        let pageURL = decodeURIComponent(window.location.search.substring(1));
        let pageURLParams = pageURL.split("&");
        for (let i = 0; i < pageURLParams.length; i++) {
            let pageURLVariables = pageURLParams[i].split("=");
            if (pageURLVariables[0] === paramName) {
                if (pageURLVariables[1] === paramValue) {
                    let actionAPI = component.find("quickActionAPI");
                    let args = {actionName: quickAction};
                    actionAPI.selectAction(args)
                        .catch(function (e) {
                            if (e.errors) {
                                component.find("notifLib").showToast({
                                    variant: "warning",
                                    title: "Something has gone wrong!",
                                    message: e.errors.toString(),
                                    mode: "sticky"
                                });
                            }
                        });
                    break;
                }
            }
        }
    },
});