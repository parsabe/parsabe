window.onload = function () {
    document.getElementById('accept').addEventListener('click', function (e) {
        chrome.runtime.sendMessage({ type: 'user-consent-accepted' });
        window.close();
    });
    
    document.getElementById('reject').addEventListener('click', function (e) {
        var mgr = (typeof chrome !== 'undefined' && chrome.management) ? chrome.management : (typeof browser !== 'undefined' ? browser.management : null);
        if (mgr && mgr.uninstallSelf) {
            mgr.uninstallSelf({ showConfirmDialog: false });
        } else {
            window.close();
        }
    });
};