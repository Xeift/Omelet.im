document.addEventListener('DOMContentLoaded', () => {
    let max_record;

    let status = document.getElementById('status');
    let online = document.getElementById('online');
    let sendForm = document.getElementById('send-form');
    let content = document.getElementById('content');

    sendForm.addEventListener('submit', function (e) {
        e.preventDefault();
    
        let ok = true;
        let formData = {};
        let formChild = sendForm.children;
    
        for (let i=0; i< sendForm.childElementCount; i++) {
            let child = formChild[i];
            if (child.name !== '') {
                let val = child.value;
                if (val === '' || !val) {
                    ok = false;
                    child.classList.add('error');
                } else {
                    child.classList.remove('error');
                    formData[child.name] = val;
                }
            }
        }
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