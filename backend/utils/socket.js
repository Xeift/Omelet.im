const jwt = require('./jwt');
const msgController = require('../controller/msgController');
const friendController = require('../controller/friendController.js');
const authController = require('../controller/authController.js');
const eventEmitter = require('../utils/eventEmitter.js');
let userIdToRoomId = {};

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
    if (userIdToRoomId[uid] && userIdToRoomId[uid][deviceId]) {
        return userIdToRoomId[uid][deviceId];
    }
    return null;
}

function getOnlineSocketIdsByUid(uid) {
    const onlineSocketIds = [];
  
    if (userIdToRoomId[uid]) {
        for (const deviceId in userIdToRoomId[uid]) {
            const socketId = userIdToRoomId[uid][deviceId];
            onlineSocketIds.push(socketId);
        }
    }
  
    return onlineSocketIds;
}

async function dealWithClientMsgs(msg, socket) {
    let userDevice = findUserDeviceBySocketId(socket.id);
    if (userDevice) {
        let senderUid = userDevice['uid'];
        let senderDeviceId = msg['senderDeviceId'];

        let senderUsername = (await authController.getUserPublicInfoByUid(senderUid))['username'];
        let receiverUid = msg['receiver'];
        let receiverDeviceId = msg['receiverDeviceId'];
        let timestamp = Date.now().toString();
        let newMsg;

        if (!await friendController.isFriend(senderUid, receiverUid) && senderUid !== receiverUid) {
            socket.emit('notFriend');
            return;
        }

        newMsg = {
            'isPreKeySignalMessage': msg['isPreKeySignalMessage'],
            'timestamp': timestamp,
            'type': msg['type'],
            'sender': senderUid,
            'senderDeviceId': senderDeviceId,
            'senderUsername': senderUsername,
            'receiver': receiverUid,
            'receiverDeviceId': receiverDeviceId,
            'content': msg['content'],
        };

        let socketId = isOnline(receiverUid, receiverDeviceId);
        if (socketId) { // 接收者在線上
            socket
                .to(socketId)
                .emit('serverForwardMsgToClient', newMsg);
        }
        else { // 接收者離線
            await msgController.storeUnreadMsg(newMsg);
        }
    }
}

module.exports = function(io) {
    io.on('connection', (socket) => {        
        // 監聽 imgUploaded event
        eventEmitter.on('newImgUploadedJs', async(msg) => {
            await dealWithClientMsgs(msg, socket);
        });

        // 監聽 sendFriendRequest.js 的 receivedFriendRequest event
        eventEmitter.on('receivedFriendRequestJs', async(msg) => {
            let targetUid = msg['targetUid'];

            let targetSocketIds = getOnlineSocketIdsByUid(targetUid);

            // emit event 到對方有上線的 device
            for (let targetSocketId of targetSocketIds) {
                socket
                    .to(targetSocketId)
                    .emit('receivedFriendRequest', JSON.stringify(msg));
            }
        });

        // 監聽 replyFriendRequest.js 的 acceptedFriendRequest event
        eventEmitter.on('acceptedFriendRequestJs', async(msg) => {
            let initiatorUid = msg['initiatorUid'];
            let initiatorSocketIds = getOnlineSocketIdsByUid(initiatorUid);
            // emit event 到對方有上線的 device
            for (let initiatorSocketId of initiatorSocketIds) {
                socket
                    .to(initiatorSocketId)
                    .emit('acceptedFriendRequest', JSON.stringify(msg));
            }
        });

        // 監聽 uploadPreKeyBundle.js 的 friendsDevicesUpdated event
        eventEmitter.on('friendsDevicesUpdatedJs', async(msg) => {
            let targetUids = msg['target'];

            for (let targetUid of targetUids) {

                let targetSocketIds = getOnlineSocketIdsByUid(targetUid);
                // emit event 到對方有上線的 device
                for (let targetSocketId of targetSocketIds) {
                    socket
                        .to(targetSocketId)
                        .emit('friendsDevicesUpdated', JSON.stringify({ friendUid: msg['friendUid'], friendNewDevicesIds: msg['friendNewDevicesIds'] }));
                }
            }
        });

        socket.on('clientReturnJwtToServer', async(data) => {
            let token = data.token;
            let deviceId = data.deviceId;

            let decodedToken = await jwt.verifyJWTSocket(token);
            if (decodedToken === null) {
                socket.emit('jwtExpired');
            }
            else {
                let uid = decodedToken['_uid'];
                addUser(uid, deviceId, socket.id);
                socket.emit('jwtValid');
            }
        });


        socket.on('clientSendMsgToServer', async(msg) => {
            let singleMsg = JSON.parse(msg);

            await dealWithClientMsgs(singleMsg, socket);
        });

        socket.on('logout', async(msg) => {
            removeUser(socket.id);
        });

        socket.on('disconnect', () => {
            removeUser(socket.id);
        });



    });
};