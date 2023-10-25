const RoomModel = require('../model/roomModel');
const MsgModel = require('../model/msgModel');
const snowflakeId = require('../utils/snowflakeId');

async function createNewRoom(name, type) {
    let rid = snowflakeId.generateId();
    await RoomModel.create({
        rid: rid,
        name: name,
        type: type,
        timestamp: snowflakeId.extractTimeStampFromId(rid),
        members: []
    });
}

async function storeUnreadMsg(timestamp, type, receiver, sender, content) {
    await MsgModel.create({
        timestamp: timestamp,
        type: type,
        receiver: receiver,
        sender: sender,
        content: content
    });
}

async function readUnreadMsg(receiver) {
    let unreadMsgs = [];
    let query = { receiver: receiver };
    let cursor = await MsgModel.find(query);
    cursor.forEach(msg => {
        unreadMsgs.push(msg);
    });

    await MsgModel.deleteMany(query);

    return unreadMsgs;
}

module.exports = { createNewRoom, storeUnreadMsg, readUnreadMsg };