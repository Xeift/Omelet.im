document.addEventListener('DOMContentLoaded', () => {
    let max_record; // 新增

    let status = document.getElementById('status');
    let online = document.getElementById('online');
    let sendForm = document.getElementById('send-form'); // 加入這行
    let content = document.getElementById('content');    // 加入這行

    sendForm.addEventListener('submit', function (e) {
        e.preventDefault();
    
        let ok = true;
        let formData = {};
        let formChild = sendForm.children;
    
        for (let i=0; i< sendForm.childElementCount; i++) {
            let child = formChild[i];
            if (child.name !== '') {
                let val = child.value;
                if (val === '' || !val) {    // 如果值為空或不存在
                    ok = false;
                    child.classList.add('error');
                } else {
                    child.classList.remove('error');
                    formData[child.name] = val;
                }
            }
        }
    
        // ok 為真才能送出
        if (ok) socket.emit('send', formData);
    });

    socket.on('connect', function () {
        status.innerText = 'Connected.';
    });

    socket.on('disconnect', function () {
        status.innerText = 'Disconnected.';
    });

    socket.on('online', function (amount) {
        online.innerText = amount;
    });

    // 加入新的事件監聽器  
    socket.on('chatRecord', function (msgs) {
        for (var i=0; i < msgs.length; i++) {
            (function () {
                addMsgToBox(msgs[i]);
            })();
        }
    });
 
    socket.on('maxRecord', function (amount) {
        max_record = amount;
    });

    socket.on('msg', addMsgToBox);
 
    // 新增兩個 function
    // 新增訊息到方框中
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
 
    // 移除多餘的訊息
    function rmMsgFromBox () {
        var childs = content.children;
        childs[0].remove();
    }
});