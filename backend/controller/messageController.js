const RoomModel = require('../model/roomModel');
const snowflakeId = require('../utils/snowflakeId');

async function createNewRoom(name, type) {
    try {
        let rid = snowflakeId.generateId();
        let updatedRoom = await RoomModel.create({
            rid: rid,
            name: name,
            type: type,
            timestamp: snowflakeId.extractTimeStampFromId(rid),
            members: []
        });

        if (updatedRoom) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (err) {
        return `後端發生例外錯誤： ${err.message}`;
    }
}

module.exports = { createNewRoom };