const generateId = require('./snowflakeId');

let userIdToRoomId = {};

module.exports = function(io) {
    io.on('connection', (socket) => {
        console.log('----------------\n[utils/socket.js] a user connected\n----------------\n');

        // // TODO: 1 generate roomID
        // socket.id = generateId.generateId();
        // socket.join(socket.id);
        // socket.emit('roomID', socket.id);
        
        // // TODO: 4 receive private message from client
        // socket.on('newPrivateMsg', (receiverId, message) => {
        //     // TODO: 5 向接收者的room發送私訊事件和資料
        //     socket.to(receiverId).emit('newPrivateMsg', socket.id, message);
        // });

        userIdToRoomId[uid] = socket.id;

        socket.on('sendMsgToBackend', (content) => {
            userIdToRoomId[content.senderID] = socket.id;
            console.log(content);
            console.log(userIdToRoomId);
            socket.to(content.receiverID).emit('sendMsgToClient', content.msg);
        });
    });
};