(function () {
    var requests = [];
    var blockedHosts = [];
    var videoUrls = [];
    var fileExts = [];
    var vidExts = [];
    var isXDMUp = true;
    var monitoring = true;
    var debug = false;
    var xdmHost = "http://127.0.0.1:9614";
    var disabled = false;
    var lastIcon;
    var lastPopup;
    var videoList = [];
    var mimeList = [];

    var browserAction = chrome.action || chrome.browserAction;

    var log = function (msg) {
        if (debug) {
            try {
                console.log("[XDM]", msg);
            } catch (e) {
            }
        }
    };

    var httpPost = function (url, data) {
        return fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'text/plain;charset=UTF-8'
            },
            body: data
        }).catch(function (e) {
            log("HTTP POST error: " + e);
        });
    };

    var httpGet = function (url) {
        return fetch(url).then(function (res) {
            if (!res.ok) throw new Error("HTTP error " + res.status);
            return res.text();
        });
    };

    var getStorage = function (key, callback) {
        if (chrome.storage && chrome.storage.local) {
            chrome.storage.local.get([key], function (res) {
                callback(res ? res[key] : null);
            });
        } else if (typeof localStorage !== 'undefined') {
            callback(localStorage.getItem(key));
        } else {
            callback(null);
        }
    };

    var setStorage = function (key, val, callback) {
        if (chrome.storage && chrome.storage.local) {
            var obj = {};
            obj[key] = val;
            chrome.storage.local.set(obj, callback);
        } else if (typeof localStorage !== 'undefined') {
            localStorage.setItem(key, val);
            if (callback) callback();
        } else {
            if (callback) callback();
        }
    };

    var processRequest = function (request, response) {
        if (shouldInterceptFile(request, response)) {
            var file = getAttachedFile(response);
            if (!file) {
                file = getFileFromUrl(response.url);
            }
            sendToXDM(request, response, file, false);
            return { redirectUrl: "http://127.0.0.1:9614/204" };
        } else {
            checkForVideo(request, response);
        }
    };

    var sendToXDM = function (request, response, file, video) {
        log("sending to xdm: " + response.url);
        var data = "url=" + response.url + "\r\n";
        if (file) {
            data += "file=" + file + "\r\n";
        }
        if (request && request.requestHeaders) {
            for (var i = 0; i < request.requestHeaders.length; i++) {
                data += "req=" + request.requestHeaders[i].name + ":" + request.requestHeaders[i].value + "\r\n";
            }
        }
        if (response && response.responseHeaders) {
            for (var i = 0; i < response.responseHeaders.length; i++) {
                data += "res=" + response.responseHeaders[i].name + ":" + response.responseHeaders[i].value + "\r\n";
            }
        }
        if (request) {
            data += "res=tabId:" + request.tabId + "\r\n";
        }
        data += "res=realUA:" + navigator.userAgent + "\r\n";
        chrome.cookies.getAll({ "url": response.url }, function (cookies) {
            if (cookies) {
                for (var i = 0; i < cookies.length; i++) {
                    var cookie = cookies[i];
                    data += "cookie=" + cookie.name + ":" + cookie.value + "\r\n";
                }
            }
            log(data);
            httpPost(xdmHost + (video ? "/video" : "/download"), data);
        });
    };

    var sendRecUrl = function (urls, index, data) {
        if (index == urls.length - 1) {
            log(data);
            httpPost(xdmHost + "/links", data);
            return;
        }
        var url = urls[index];
        data += "url=" + url + "\r\n";
        data += "res=realUA:" + navigator.userAgent + "\r\n";
        chrome.cookies.getAll({ "url": url }, function (cookies) {
            if (cookies) {
                for (var i = 0; i < cookies.length; i++) {
                    var cookie = cookies[i];
                    data += "cookie=" + cookie.name + ":" + cookie.value + "\r\n";
                }
            }
            data += "\r\n\r\n";
            sendRecUrl(urls, index + 1, data);
        });
    };

    var sendUrlsToXDM = function (urls) {
        if (!urls || urls.length === 0) return;
        sendRecUrl(urls, 0, "");
    };

    var sendUrlToXDM = function (url) {
        log("sending to xdm: " + url);
        var data = "url=" + url + "\r\n";
        data += "res=realUA:" + navigator.userAgent + "\r\n";
        chrome.cookies.getAll({ "url": url }, function (cookies) {
            if (cookies) {
                for (var i = 0; i < cookies.length; i++) {
                    var cookie = cookies[i];
                    data += "cookie=" + cookie.name + ":" + cookie.value + "\r\n";
                }
            }
            log(data);
            httpPost(xdmHost + "/download", data);
        });
    };

    var sendImageToXDM = function (info, tab) {
        var url;
        if (info.mediaType) {
            if ("image" == info.mediaType) {
                if (info.srcUrl) {
                    url = info.srcUrl;
                }
            }
        }

        if (!url) {
            url = info.linkUrl;
        }
        if (!url) {
            url = info.pageUrl;
        }
        if (!url) {
            return;
        }
        sendUrlToXDM(url);
    };

    var sendLinkToXDM = function (info, tab) {
        var url = info.linkUrl;
        if (!url) {
            if (info.mediaType) {
                if ("video" == info.mediaType || "audio" == info.mediaType) {
                    if (info.srcUrl) {
                        url = info.srcUrl;
                    }
                }
            }
        }
        if (!url) {
            url = info.pageUrl;
        }
        if (!url) {
            return;
        }
        sendUrlToXDM(url);
    };

    var runContentScript = function (info, tab) {
        log("running content script");
        var targetTabId = (tab && tab.id) || (info && info.tabId);
        if (chrome.scripting && chrome.scripting.executeScript) {
            if (targetTabId && targetTabId !== -1) {
                chrome.scripting.executeScript({
                    target: { tabId: targetTabId },
                    files: ['contentscript.js']
                });
            } else {
                chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
                    if (tabs && tabs[0] && tabs[0].id) {
                        chrome.scripting.executeScript({
                            target: { tabId: tabs[0].id },
                            files: ['contentscript.js']
                        });
                    }
                });
            }
        } else if (chrome.tabs && chrome.tabs.executeScript) {
            chrome.tabs.executeScript({
                file: 'contentscript.js'
            });
        }
    };

    var isVideoMime = function (mimeText) {
        if (!mimeList) {
            return false;
        }
        var mime = mimeText.toLowerCase();
        for (var i = 0; i < mimeList.length; i++) {
            if (mime.indexOf(mimeList[i]) != -1) {
                return true;
            }
        }
        return false;
    };

    var checkForVideo = function (request, response) {
        var mime = "";
        var video = false;
        var url = response.url;

        if (response.responseHeaders) {
            for (var i = 0; i < response.responseHeaders.length; i++) {
                if (response.responseHeaders[i].name.toLowerCase() == "content-type") {
                    mime = response.responseHeaders[i].value.toLocaleLowerCase();
                    break;
                }
            }
        }

        if (mime.startsWith("audio/") || mime.startsWith("video/") ||
            mime.indexOf("mpegurl") > 0 || mime.indexOf("f4m") > 0 || isVideoMime(mime)) {
            log("Checking video mime: " + mime + " " + JSON.stringify(mimeList));
            video = true;
        }

        if (!video) {
            if (videoUrls) {
                for (var i = 0; i < videoUrls.length; i++) {
                    var arr = videoUrls[i].split("|");
                    var matched = true;
                    for (var j = 0; j < arr.length; j++) {
                        if (url.indexOf(arr[j]) < 0) {
                            matched = false;
                            break;
                        }
                    }
                    if (matched) {
                        video = true;
                        log(url);
                        break;
                    }
                }
            }
        }

        if (!video) {
            if (vidExts) {
                var file = getFileFromUrl(url);
                var ext = getFileExtension(file);
                if (ext) {
                    ext = ext.toUpperCase();
                }
                for (var i = 0; i < vidExts.length; i++) {
                    if (vidExts[i] == ext) {
                        video = true;
                        break;
                    }
                }
            }
        }

        if (video) {
            if (request && request.tabId != -1) {
                chrome.tabs.get(
                    request.tabId,
                    function (tab) {
                        sendToXDM(request, response, (tab && tab.title) ? tab.title : null, true);
                    }
                );
            } else {
                sendToXDM(request, response, null, true);
            }
        }
    };

    var getAttachedFile = function (response) {
        if (!response || !response.responseHeaders) return;
        for (var i = 0; i < response.responseHeaders.length; i++) {
            if (response.responseHeaders[i].name.toLowerCase() == 'content-disposition') {
                return getFileFromContentDisposition(response.responseHeaders[i].value);
            }
        }
    };

    var isHtml = function (response) {
        if (!response || !response.responseHeaders) return false;
        for (var i = 0; i < response.responseHeaders.length; i++) {
            if (response.responseHeaders[i].name.toLowerCase() == 'content-type') {
                return (response.responseHeaders[i].value.indexOf("text/html") != -1);
            }
        }
        return false;
    };

    var shouldInterceptFile = function (request, response) {
        var url = response.url;
        var isAttachment = false;
        if (isBlocked(url)) {
            return false;
        }

        if (isHtml(response)) {
            return false;
        }
        var file = getAttachedFile(response);
        if (!file) {
            file = getFileFromUrl(url);
        } else {
            isAttachment = true;
        }
        var ext = getFileExtension(file);
        if (ext) {
            if (!isAttachment) {
                for (var i = 0; i < vidExts.length; i++) {
                    if (vidExts[i] == ext.toUpperCase()) {
                        return false;
                    }
                }
            }
            for (var i = 0; i < fileExts.length; i++) {
                if (fileExts[i] == ext.toUpperCase()) {
                    return true;
                }
            }
        }
        return false;
    };

    var isBlocked = function (url) {
        for (var i = 0; i < blockedHosts.length; i++) {
            var parsed = parseUrl(url);
            if (parsed && blockedHosts[i] == parsed.hostname) {
                return true;
            }
        }
        return false;
    };

    var syncXDM = function () {
        httpGet(xdmHost + "/sync")
            .then(function (responseText) {
                var data = JSON.parse(responseText);
                monitoring = data.enabled;
                blockedHosts = data.blockedHosts || [];
                videoUrls = data.videoUrls || [];
                fileExts = data.fileExts || [];
                vidExts = data.vidExts || [];
                isXDMUp = true;
                videoList = data.vidList || [];
                if (data.mimeList) {
                    mimeList = data.mimeList;
                }
                updateBrowserAction();
            })
            .catch(function () {
                isXDMUp = false;
                monitoring = false;
                updateBrowserAction();
            });
    };

    var getFileFromUrl = function (str) {
        var p = parseUrl(str);
        return p ? p.pathname : str;
    };

    var getFileFromContentDisposition = function (str) {
        var arr = str.split(";");
        for (var i = 0; i < arr.length; i++) {
            var ln = arr[i].trim();
            if (ln.indexOf("filename=") != -1) {
                var arr2 = ln.split("=");
                return arr2[1].replace(/"/g, '').trim();
            }
        }
    };

    var getFileExtension = function (file) {
        if (!file) return;
        var index = file.lastIndexOf(".");
        if (index > 0) {
            return file.substr(index + 1);
        }
    };

    var parseUrl = function (str) {
        if (!str) return null;
        var match = str.match(/^(https?\:)\/\/(([^:\/?#]*)(?:\:([0-9]+))?)([\/]{0,1}[^?#]*)(\?[^#]*|)(#.*|)$/);
        return match && {
            href: str,
            protocol: match[1],
            host: match[2],
            hostname: match[3],
            port: match[4],
            pathname: match[5],
            search: match[6],
            hash: match[7]
        };
    };

    var removeRequest = function (requestId) {
        for (var i = 0; i < requests.length; i++) {
            if (requests[i].requestId == requestId) {
                return requests.splice(i, 1);
            }
        }
    };

    var updateBrowserAction = function () {
        if (!browserAction) return;
        if (!isXDMUp) {
            setBrowserActionPopUp("fatal.html");
            setBrowserActionIcon("icon_blocked.png");
            return;
        }
        if (monitoring) {
            if (disabled) {
                setBrowserActionIcon("icon_disabled.png");
            } else {
                setBrowserActionIcon("icon.png");
            }
            setBrowserActionPopUp("status.html");
        } else {
            setBrowserActionIcon("icon_disabled.png");
            setBrowserActionPopUp("disabled.html");
        }

        if (videoList && videoList.length > 0) {
            browserAction.setBadgeText({ text: videoList.length + "" });
        } else {
            browserAction.setBadgeText({ text: "" });
        }
    };

    var setBrowserActionIcon = function (icon) {
        if (!browserAction || lastIcon == icon) {
            return;
        }
        browserAction.setIcon({ path: icon });
        lastIcon = icon;
    };

    var setBrowserActionPopUp = function (pop) {
        if (!browserAction || lastPopup == pop) {
            return;
        }
        browserAction.setPopup({ popup: pop });
        lastPopup = pop;
    };

    var initSelf = function () {
        // Track request headers
        try {
            chrome.webRequest.onSendHeaders.addListener(
                function (info) { requests.push(info); },
                { urls: ["http://*/*", "https://*/*"] },
                ["requestHeaders", "extraHeaders"]
            );
        } catch (e) {
            chrome.webRequest.onSendHeaders.addListener(
                function (info) { requests.push(info); },
                { urls: ["http://*/*", "https://*/*"] },
                ["requestHeaders"]
            );
        }

        chrome.webRequest.onCompleted.addListener(
            function (info) {
                removeRequest(info.requestId);
            },
            { urls: ["http://*/*", "https://*/*"] }
        );

        chrome.webRequest.onErrorOccurred.addListener(
            function (info) {
                removeRequest(info.requestId);
            },
            { urls: ["http://*/*", "https://*/*"] }
        );

        // Try blocking webRequest (MV2 / enterprise MV3); fallback to observation (MV3 standard)
        var blockingConfigured = false;
        try {
            chrome.webRequest.onHeadersReceived.addListener(
                function (response) {
                    var reqs = removeRequest(response.requestId);
                    if (!isXDMUp || !monitoring || disabled) return;
                    if (!(response.statusLine.indexOf("200") > 0 || response.statusLine.indexOf("206") > 0)) return;

                    if (reqs && reqs.length == 1) {
                        if (!(response.url + "").startsWith(xdmHost)) {
                            return processRequest(reqs[0], response);
                        }
                    }
                },
                { urls: ["http://*/*", "https://*/*"] },
                ["blocking", "responseHeaders", "extraHeaders"]
            );
            blockingConfigured = true;
        } catch (e1) {
            try {
                chrome.webRequest.onHeadersReceived.addListener(
                    function (response) {
                        var reqs = removeRequest(response.requestId);
                        if (!isXDMUp || !monitoring || disabled) return;
                        if (!(response.statusLine.indexOf("200") > 0 || response.statusLine.indexOf("206") > 0)) return;

                        if (reqs && reqs.length == 1) {
                            if (!(response.url + "").startsWith(xdmHost)) {
                                return processRequest(reqs[0], response);
                            }
                        }
                    },
                    { urls: ["http://*/*", "https://*/*"] },
                    ["blocking", "responseHeaders"]
                );
                blockingConfigured = true;
            } catch (e2) {
                blockingConfigured = false;
            }
        }

        // If blocking is not supported in this runtime (e.g. standard MV3), use observational webRequest for video sniffing
        if (!blockingConfigured) {
            var headersSpec = ["responseHeaders"];
            try {
                headersSpec.push("extraHeaders");
                chrome.webRequest.onHeadersReceived.addListener(
                    function (response) {
                        var reqs = removeRequest(response.requestId);
                        if (!isXDMUp || !monitoring || disabled) return;
                        if (!(response.statusLine.indexOf("200") > 0 || response.statusLine.indexOf("206") > 0)) return;

                        if (reqs && reqs.length == 1) {
                            if (!(response.url + "").startsWith(xdmHost)) {
                                checkForVideo(reqs[0], response);
                            }
                        }
                    },
                    { urls: ["http://*/*", "https://*/*"] },
                    headersSpec
                );
            } catch (e) {
                chrome.webRequest.onHeadersReceived.addListener(
                    function (response) {
                        var reqs = removeRequest(response.requestId);
                        if (!isXDMUp || !monitoring || disabled) return;
                        if (!(response.statusLine.indexOf("200") > 0 || response.statusLine.indexOf("206") > 0)) return;

                        if (reqs && reqs.length == 1) {
                            if (!(response.url + "").startsWith(xdmHost)) {
                                checkForVideo(reqs[0], response);
                            }
                        }
                    },
                    { urls: ["http://*/*", "https://*/*"] },
                    ["responseHeaders"]
                );
            }

            // And intercept file downloads via chrome.downloads API in Chromium
            if (chrome.downloads && chrome.downloads.onCreated) {
                chrome.downloads.onCreated.addListener(function (downloadItem) {
                    if (!isXDMUp || !monitoring || disabled) return;
                    if (!downloadItem.url || downloadItem.url.startsWith(xdmHost)) return;

                    var url = downloadItem.finalUrl || downloadItem.url;
                    if (isBlocked(url)) return;

                    var file = downloadItem.filename || getFileFromUrl(url);
                    var ext = getFileExtension(file);
                    if (ext) {
                        var shouldIntercept = false;
                        for (var i = 0; i < fileExts.length; i++) {
                            if (fileExts[i] == ext.toUpperCase()) {
                                shouldIntercept = true;
                                break;
                            }
                        }
                        if (shouldIntercept) {
                            chrome.downloads.cancel(downloadItem.id, function () {
                                chrome.downloads.erase({ id: downloadItem.id }, function () {});
                            });
                            sendUrlToXDM(url);
                        }
                    }
                });
            }
        }

        // Sync with XDM periodically
        syncXDM();
        setInterval(function () { syncXDM(); }, 5000);

        if (chrome.alarms) {
            chrome.alarms.create("syncXDM", { periodInMinutes: 1 });
            chrome.alarms.onAlarm.addListener(function (alarm) {
                if (alarm.name === "syncXDM") {
                    syncXDM();
                }
            });
        }

        chrome.runtime.onMessage.addListener(
            function (request, sender, sendResponse) {
                if (request.type === "links") {
                    sendUrlsToXDM(request.links || []);
                    sendResponse({ done: "done" });
                } else if (request.type === "stat") {
                    sendResponse({ isDisabled: disabled, list: videoList });
                } else if (request.type === "cmd") {
                    disabled = request.disable;
                    log("disabled " + disabled);
                } else if (request.type === "vid") {
                    httpPost(xdmHost + "/item", request.itemId);
                } else if (request.type === "clear") {
                    httpGet(xdmHost + "/clear").catch(function () {});
                }
            }
        );

        if (chrome.commands && chrome.commands.onCommand) {
            chrome.commands.onCommand.addListener(function (command) {
                if (isXDMUp && monitoring) {
                    log("toggle command called");
                    disabled = !disabled;
                    updateBrowserAction();
                }
            });
        }

        // Context Menus
        if (chrome.contextMenus) {
            chrome.contextMenus.removeAll(function () {
                chrome.contextMenus.create({
                    id: "xdm_download_link",
                    title: "Download with XDM",
                    contexts: ["link", "video", "audio"]
                }, function () { if (chrome.runtime.lastError) {} });

                chrome.contextMenus.create({
                    id: "xdm_download_image",
                    title: "Download Image with XDM",
                    contexts: ["image"]
                }, function () { if (chrome.runtime.lastError) {} });

                chrome.contextMenus.create({
                    id: "xdm_download_all",
                    title: "Download all links",
                    contexts: ["all"]
                }, function () { if (chrome.runtime.lastError) {} });
            });

            chrome.contextMenus.onClicked.addListener(function (info, tab) {
                if (info.menuItemId === "xdm_download_link") {
                    sendLinkToXDM(info, tab);
                } else if (info.menuItemId === "xdm_download_image") {
                    sendImageToXDM(info, tab);
                } else if (info.menuItemId === "xdm_download_all") {
                    runContentScript(info, tab);
                }
            });
        }
    };

    var getUserConcent = function () {
        log("user consent check");
        getStorage("xdm-first-run-key", function (consented) {
            if (!consented) {
                chrome.tabs.create({ url: "consent.html" });
                var consentListener = function (request, sender, sendResponse) {
                    if (request.type === "user-consent-accepted") {
                        setStorage("xdm-first-run-key", "true", function () {
                            chrome.runtime.onMessage.removeListener(consentListener);
                            initSelf();
                        });
                    }
                };
                chrome.runtime.onMessage.addListener(consentListener);
            } else {
                initSelf();
            }
        });
    };

    getUserConcent();
    log("loaded");
})();
