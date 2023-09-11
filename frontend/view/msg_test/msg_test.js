var socket = io('http://localhost:3000');
socket.on('connect', function(){
    console.log('已連接到後端');

    // TODO: 2 store roomID
    socket.on('roomID', (roomID) => {
        localStorage.setItem('roomID', roomID);
        console.log(roomID);
    });

    // TODO: 3 send private message to backend
    let msg = 'mdfk';
    let targetRoomId = '';
    socket.to(targetRoomId).emit('newPrivateMsg', msg);
});






