window.onload = function () {
    var contentEl = document.getElementById('content');
    if (contentEl) contentEl.style.display = 'none';

    chrome.runtime.sendMessage({ type: "stat" }, function (response) {
        if (!response) return;

        var chk = document.getElementById("chk");
        if (chk) chk.checked = !response.isDisabled;

        var button = document.getElementById('clear');
        if (button) {
            button.addEventListener('click', function (e) {
                chrome.runtime.sendMessage({ type: "clear" });
                window.close();
            });
        }

        var fmtBtn = document.getElementById('format');
        if (fmtBtn) {
            fmtBtn.addEventListener('click', function (e) {
                alert("Please select desired format in web player");
            });
        }

        if (response.list && response.list.length > 0) {
            if (contentEl) contentEl.style.display = 'block';
        }

        renderList(response.list || []);
    });

    var chkEl = document.getElementById("chk");
    if (chkEl) {
        chkEl.addEventListener('click', function () {
            chrome.runtime.sendMessage({ type: "cmd", disable: !this.checked });
            window.close();
        });
    }
};

function toUTF8(str) {
    var text = "";
    var arr = str.split(",");
    for (var i = 0; i < arr.length; i++) {
        text += String.fromCharCode(arr[i]);
    }
    return text;
}

function renderList(arr) {
    var table = document.getElementById("table");
    if (!table) return;

    for (var i = 0; i < arr.length; i++) {
        var listItem = arr[i];
        var text = toUTF8(listItem.text);
        var info = listItem.info;
        var id = listItem.id;

        var row = table.insertRow(0);
        var cell = row.insertCell(0);

        var border = "";
        var div = document.createElement('div');
        div.setAttribute("style", "padding: 10px; display: flex; flex-direction: column;" + border);

        var p1 = document.createElement('span');
        p1.id = listItem.id;
        p1.setAttribute("style", "font-family:helvetica,arial,courier; font-size: 14px; cursor: pointer;");
        var node = document.createTextNode(text);
        p1.appendChild(node);

        var p2 = document.createElement('span');
        p2.setAttribute("style", "font-family:helvetica,arial,courier; font-size: 12px;");
        node = document.createTextNode(info);
        p2.appendChild(node);

        div.appendChild(p1);
        div.appendChild(p2);

        cell.appendChild(div);

        div.addEventListener('click', function (e) {
            chrome.runtime.sendMessage({ type: "vid", itemId: e.target.id });
            window.close();
        });
    }
}
