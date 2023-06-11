document.addEventListener('DOMContentLoaded', () => {
    let max_record;

    let status = document.getElementById('status');
    let online = document.getElementById('online');
    let sendForm = document.getElementById('send-form');
    let content = document.getElementById('content');

    sendForm.addEventListener('submit', function (e) { // 按下送出表單按鈕
        e.preventDefault(); // 阻止表單預設行為
    
        let ok = true;
        let formData = {};
        let formChild = sendForm.children; // 取得表單中所有子元素
    
        for (let i=0; i< sendForm.childElementCount; i++) {
            let child = formChild[i];
            if (child.name !== '') { // 處理表單為空的狀況
                let val = child.value;
                if (val === '' || !val) {
                    ok = false; // 禁止傳送
                    child.classList.add('error');
                } else {
                    child.classList.remove('error');
                    formData[child.name] = val; // 設 formChild 為表單內容
                }
            }
        }
        if (ok) socket.emit('send', formData); // 狀態正常則發送
    });

    socket.on('connect', function () { // 連接
        status.innerText = 'Connected.';
    });

    socket.on('disconnect', function () { // 中斷連接
        status.innerText = 'Disconnected.';
    });

    socket.on('online', function (amount) { // 上線
        online.innerText = amount;
    });

    socket.on('chatRecord', function (msgs) { // 聊天記錄
        for (var i=0; i < msgs.length; i++) {
            (function () {
                addMsgToBox(msgs[i]);
            })();
        }
    });
 
    socket.on('maxRecord', function (amount) { // 最大聊天記錄
        max_record = amount;
    });

    socket.on('msg', addMsgToBox); // 新訊息
 
    function addMsgToBox (d) {
        var msgBox = document.createElement('div')
            msgBox.className = 'msg';
        var nameBox = document.createElement('span');
            nameBox.className = 'name';
        var name = document.createTextNode(d.name);
        var msg = document.createTextNode(d.msg);
 
        nameBox.appendChild(name);
        msgBox.appendChild(nameBox);
        msgBox.appendChild(msg);
        content.appendChild(msgBox);
 
        if (content.children.length > max_record) {
            rmMsgFromBox();
        }
    }
 
    function rmMsgFromBox () {
        var childs = content.children;
        childs[0].remove();
    }
});