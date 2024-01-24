const generateId = require('./snowflakeId');
const jwt = require('./jwt');
const msgController = require('./../controller/msgController');
const authController = require('./../controller/authController');

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
            }
        });

        socket.on('clientSendMsgToServer', async(msg) => {
            
            console.log(`Msg👉 ${JSON.stringify(msg)}`);

            let senderUid = Object.entries(userIdToRoomId).find(([uid, socketId]) => socketId === socket.id);
            if (senderUid) {
                senderUid = senderUid[0];
                let receiverUid = msg['receiver'];
                let timestamp = Date.now().toString();
                let newMsg;
                console.log(typeof(msg));
                console.log(`🎨🎨${msg['spkId']}`);
                console.log(`🎨🎨${msg.spkId}`);
                console.log(`🎨🎨${msg.spkId === null}`);

                if (msg['spkId'] === null) { // 第二次以後發送訊息
                    console.log('two🧨🎇');
                    newMsg = {
                        'timestamp': timestamp,
                        'type': msg['type'],
                        'sender': senderUid,
                        'receiver': receiverUid,
                        'content': msg['content'],
                    };
                }
                else { // 第一次發送訊息
                    console.log('one🧨🎇');
                    console.log(`delete opk id: ${msg['opkId']}!!!`);
                    await authController.deleteOpkPub(receiverUid, msg['opkId']);
                    newMsg = {
                        'timestamp': timestamp,
                        'type': msg['type'],
                        'sender': senderUid,
                        'receiver': receiverUid,
                        'content': msg['content'],
                        'spkId': msg['spkId'],
                        'opkId': msg['opkId'],
                    };
                }        

                console.log('--------------------------------');
                console.log('clientSendMsgToServer');
                console.log('已連線過');
                console.log(`newMsg👉 ${JSON.stringify(newMsg)}`);
                console.log('--------------------------------\n');
    
                if (receiverUid in userIdToRoomId) { // 接收者在線上
                    console.log('--------------------------------');
                    console.log('receiver online');
                    console.log('--------------------------------\n');
                    socket
                        .to(userIdToRoomId[receiverUid])
                        .emit('serverForwardMsgToClient', newMsg);
                    console.log('done emit serverForwardMsgToClient');
                }
                else { // 接收者離線
                    console.log('--------------------------------');
                    console.log('receiver offline');
                    console.log('--------------------------------\n');
                    await msgController.storeUnreadMsg(newMsg);
                }
            }
            else {
                console.log('第一次連線 未進行 clientReturnJwtToServer');
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

