const { v4: uuidv4 } = require('uuid');

module.exports = function(io) {
    io.on('connection', (socket) => {
        console.log('----------------\n[utils/socket.js] a user connected\n----------------\n');

        // TODO: 1 generate roomID
        socket.id = uuidv4();
        socket.join(socket.id);
        socket.emit('roomID', socket.id);
        
        // TODO: 4 receive private message from client
        socket.on('newPrivateMsg', (receiverId, message) => {
            // 向接收者的room發送私訊事件和資料
            socket.to(receiverId).emit('newPrivateMsg', socket.id, message);
        });

        // TODO: (5) [another client] receive private message from backend
        socket.on('private-message', function(data) {
            // 獲取消息內容和發送者的信息
            var message = data.message;
            var from = data.from;
            // 在聊天界面顯示消息
            console.log(message, from);
        });
    });
};