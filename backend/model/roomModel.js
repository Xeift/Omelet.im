const mongoose = require('./mongoose');

const RoomSchema = new mongoose.Schema({
    rid: { type: String, unique: true },
    timestamp: { type: Number },
    name: { type: String },
    members: { type: [String], default: [] }
});
const RoomModel = mongoose.model('Room', RoomSchema, 'rooms');

module.exports = RoomModel;