const RoomModel = require('../model/roomModel');
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

async function storeUnreadMsg(name, type) {
    // let rid = snowflakeId.generateId();
    // await RoomModel.create({
    //     rid: rid,
    //     name: name,
    //     type: type,
    //     timestamp: snowflakeId.extractTimeStampFromId(rid),
    //     members: []
    // });
}

module.exports = { createNewRoom };