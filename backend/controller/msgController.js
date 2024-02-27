const MsgModel = require('../model/msgModel');

async function storeUnreadMsg(msg) {
    await MsgModel.create(msg);
}

async function readUnreadMsg(receiver, deviceId) {
    let unreadMsgs = [];
    let query = { receiver: receiver, receiverDeviceId: deviceId };
    let cursor = await MsgModel.find(query);
    cursor.forEach(msg => {
        unreadMsgs.push(msg);
    });

    await MsgModel.deleteMany(query);

    return unreadMsgs;
}

module.exports = { storeUnreadMsg, readUnreadMsg };