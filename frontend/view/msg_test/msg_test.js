let socket = io('http://localhost:3000');
socket.on('connect', function(){
    console.log('已連接到後端');

    // TODO: 2 store roomID
    socket.on('roomID', (roomID) => {
        localStorage.setItem('roomID', roomID);
        console.log(roomID);

        // TODO: 3 send private message to backend
        let msg = 'mdfk';
        let targetRoomId = roomID;
        socket.emit('newPrivateMsg', msg);
    });
    // TODO: (6) [another client] receive private message from backend
    socket.on('newPrivateMsg', function(data) {
        // 獲取消息內容和發送者的信息
        var message = data.message;
        var from = data.from;
        // 在聊天界面顯示消息
        console.log(message, from);
    });
});

document.getElementById('create-room-btn').onclick = () => {
    console.log('clicked create');
};




