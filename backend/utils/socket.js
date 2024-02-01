const generateId = require('./snowflakeId');
const jwt = require('./jwt');
const msgController = require('./../controller/msgController');
const authController = require('./../controller/authController');

let userIdToRoomId = {};

module.exports = function(io) {
    io.on('connection', (socket) => {
        console.log('--------------------------------');
        console.log(`[socket.js] client ${socket.id} has connected to backend server`);


        socket.on('clientReturnJwtToServer', async(token) => {
            let decodedToken = await jwt.verifyJWTSocket(token);
            if (decodedToken === null) {
                console.log('[socket.js] 👉 token expired');
                socket.emit('jwtExpired');
            }
            else {
                let uid = decodedToken['_uid'];
                userIdToRoomId[uid] = socket.id;
                console.log(`[socket.js] room content👉 ${JSON.stringify(userIdToRoomId)}`);
                console.log('--------------------------------\n');
            }
        });

        socket.on('clientSendMsgToServer', async(msg) => {
            console.log('--------------------------------');
            console.log(`[socket.js] 訊息原始內容👉 ${JSON.stringify(msg)}`);

            let senderUid = Object.entries(userIdToRoomId).find(([uid, socketId]) => socketId === socket.id);
            if (senderUid) {
                senderUid = senderUid[0];
                let receiverUid = msg['receiver'];
                let timestamp = Date.now().toString();
                let newMsg;

                if (msg['isPreKeySignalMessage']) { // 第一次發送訊息
                    console.log('[socket.js] 此訊息為 PreKeySignalMessage');
                    // 刪除傳送訊息時使用的 OPK
                    if (msg['opkId']) {
                        console.log(`[socket.js] 刪除opkid👉 ${msg['opkId']}`);
                        await authController.deleteOpkPub(receiverUid, msg['opkId']);
                    }

                }
                else { // 第二次以後發送訊息
                    console.log('[socket.js] 此訊息為 SignalMessage');
                }
                newMsg = {
                    'isPreKeySignalMessage': msg['isPreKeySignalMessage'],
                    'timestamp': timestamp,
                    'type': msg['type'],
                    'sender': senderUid,
                    'receiver': receiverUid,
                    'content': msg['content'],
                };


                console.log(`[socket.js] 轉發至客戶端的訊息👉 ${JSON.stringify(newMsg)}`);
    
                if (receiverUid in userIdToRoomId) { // 接收者在線上
                    console.log('[socket.js] receiver online');
                    socket
                        .to(userIdToRoomId[receiverUid])
                        .emit('serverForwardMsgToClient', newMsg);
                    console.log('[socket.js] done emit serverForwardMsgToClient');
                    console.log('--------------------------------\n');
                }
                else { // 接收者離線
                    console.log('[socket.js] receiver offline');
                    console.log('--------------------------------\n');
                    await msgController.storeUnreadMsg(newMsg);
                }
            }
            else {
                console.log('[socket.js] 第一次連線 未進行 clientReturnJwtToServer');
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

