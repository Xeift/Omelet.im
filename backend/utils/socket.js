const jwt = require('./jwt');
const msgController = require('../controller/msgController');
const preKeyBundleController = require('../controller/preKeyBundleController.js');

let userIdToRoomId = {};

module.exports = function(io) {
    io.on('connection', (socket) => {
        console.log('--------------------------------');
        console.log(`[socket.js] 客戶端 ${socket.id} 已連接到後端伺服器`);
        
        socket.on('clientReturnJwtToServer', async(data) => {
            let token = data.token;
            let ipkPub = data.ipkPub;

            let decodedToken = await jwt.verifyJWTSocket(token);
            if (decodedToken === null) {
                console.log('[socket.js] 👉 token expired');
                socket.emit('jwtExpired');
            }
            else {
                let uid = decodedToken['_uid'];
                let deviceId = await preKeyBundleController.findDeviceIdByIpkPub(uid, ipkPub);

                addUser(uid, deviceId, socket.id);

                socket.emit('jwtValid');
                console.log(`[socket.js] 線上客戶端👉 ${JSON.stringify(userIdToRoomId)}`);
                console.log('--------------------------------\n');
            }
        });

        async function dealWithClientMsgs(msg) {
            console.log('--------------------------------');
            console.log(`[socket.js] 訊息原始內容👉 ${JSON.stringify(msg)}`);

            let userDevice = findUserDeviceBySocketId(socket.id);
            if (userDevice) {
                let senderUid = userDevice['uid'];
                let receiverUid = msg['receiver'];
                let receiverDeviceId = msg['receiverDeviceId'];
                let timestamp = Date.now().toString();
                let newMsg;

                if (msg['isPreKeySignalMessage']) { // 第一次發送訊息
                    console.log('[socket.js] 此訊息為 PreKeySignalMessage');
                    // 刪除傳送訊息時使用的 OPK
                    if (msg['opkId']) {
                        console.log(`[socket.js] 刪除opkid👉 ${msg['opkId']}`);
                        await preKeyBundleController.deleteOpkPub(receiverUid, msg['opkId']);
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
                    'receiverDeviceId': receiverDeviceId,
                    'content': msg['content'],
                };

                console.log(`[socket.js] 轉發至客戶端的訊息👉 ${JSON.stringify(newMsg)}`);

                let socketId = isOnline(receiverUid, receiverDeviceId);
                if (socketId) { // 接收者在線上
                    console.log(`[socket.js] receiver ${socketId} online`);
                    socket
                        .to(socketId)
                        .emit('serverForwardMsgToClient', newMsg);
                    console.log('[socket.js] receiver online\ndone emit serverForwardMsgToClient');
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
        }

        socket.on('clientSendMsgToServer', async(msg) => {
            let singleMsg = JSON.parse(msg);
            console.log(`完整訊息內容：${JSON.stringify(singleMsg)}`);

            await dealWithClientMsgs(singleMsg);
        });

        socket.on('disconnect', () => {
            removeUser(socket.id);
            console.log('--------------------------------');
            console.log(`[socket.js] 客戶端 ${socket.id} 已與後端斷開連接`);
            console.log(`[socket.js] 目前線上客戶端👉 ${JSON.stringify(userIdToRoomId)}`);
            console.log('--------------------------------\n');
        });

    });

    function addUser(userId, deviceId, socketId) {
        if (!userIdToRoomId[userId]) {
            userIdToRoomId[userId] = {};
        }
        userIdToRoomId[userId][deviceId] = socketId;
    }
    
    function removeUser(socketId) {
        for (let userId in userIdToRoomId) {
            for (let deviceId in userIdToRoomId[userId]) {
                if (userIdToRoomId[userId][deviceId] === socketId) {
                    delete userIdToRoomId[userId][deviceId];
                    break;
                }
            }
        }
    }
    
    function findUserDeviceBySocketId(socketId) {
        for (let uid in userIdToRoomId) {
            for (let deviceId in userIdToRoomId[uid]) {
                if (userIdToRoomId[uid][deviceId] === socketId) {
                    return { uid, deviceId };
                }
            }
        }
        return null;
    }

    function isOnline(uid, deviceId) {
        console.log('----------------------------------------------------------------');
        console.log(uid);
        console.log(deviceId);
        console.log(userIdToRoomId);
        console.log('----------------------------------------------------------------\n');
        if (userIdToRoomId[uid] && userIdToRoomId[uid][deviceId]) {
            return userIdToRoomId[uid][deviceId];
        }
        return null;
    }
};
