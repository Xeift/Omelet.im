const generateId = require('./snowflakeId');
const jwt = require('./jwt');

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

        socket.on('clientReturnJwtToServer', async(token) => {
            let decodedToken = await jwt.verifyJWT(token);
            let uid = decodedToken['_uid'];
            userIdToRoomId[uid] = socket.id;
            console.log(userIdToRoomId);
        });

        socket.on('clientSendMsgToServer', (content) => { // TODO:
            console.log(`內容： ${content.msg}`);
            console.log(content);
            // socket.to(content.receiverID).emit('sendMsgToClient', content.msg);
        });

        socket.on('disconnect', () => {
            let disconnectorUid = Object.keys(userIdToRoomId).find(key => userIdToRoomId[key] === socket.id);
            delete userIdToRoomId[disconnectorUid];
        });
    });
};