const generateId = require('./snowflakeId');
const jwt = require('./jwt');
const msgController = require('./../controller/msgController');

let userIdToRoomId = {};

module.exports = function(io) {
    io.on('connection', (socket) => {
        console.log('--------------------------------');
        console.log('connected to backend server');
        console.log(`client socket id👉 ${socket.id} `);


        socket.on('clientReturnJwtToServer', async(token) => {
            let decodedToken = await jwt.verifyJWTSocket(token);
            if (decodedToken === null) {
                console.log('expired token');
                socket.emit('jwtExpired');
            }
            else {
                let uid = decodedToken['_uid'];
                userIdToRoomId[uid] = socket.id;
                console.log(`room content👉 ${JSON.stringify(userIdToRoomId)}`);
                console.log('--------------------------------\n');

                socket.on('clientSendMsgToServer', async(msg) => {
                    let decodedToken = await jwt.verifyJWT(msg['token']);
                    let senderUid = decodedToken['_uid'];
                    let receiverUid = msg['receiver'];
        
                    let newMsg = {
                        'timestamp': msg['timestamp'],
                        'type': msg['type'],
                        'receiver': receiverUid,
                        'sender': senderUid,
                        'content': msg['content']
                    };
                    console.log('--------------------------------');
                    console.log(receiverUid);
                    console.log(userIdToRoomId);
                    console.log('--------------------------------');
        
                    if (receiverUid in userIdToRoomId) {
                        console.log('online');
                        socket
                            .to(userIdToRoomId[receiverUid])
                            .emit('serverForwardMsgToClient', newMsg);
                        console.log('done emit serverForwardMsgToClient');
                    }
                    else {
                        console.log('offline');
                        await msgController.storeUnreadMsg(
                            msg['timestamp'],
                            msg['type'],
                            receiverUid,
                            senderUid,
                            msg['content']
                        );
                    }
                });
            }

        });



        socket.on('disconnect', () => {
            deleteUserIdFromRoom();
        });


        function deleteUserIdFromRoom() {
            let disconnectorUid = Object.keys(userIdToRoomId).find(key => userIdToRoomId[key] === socket.id);
            delete userIdToRoomId[disconnectorUid];
        }

    });
};

