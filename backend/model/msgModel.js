const mongoose = require('./mongoose');

const UnreadMsgSchema = new mongoose.Schema({
    isPreKeySignalMessage: { type: Boolean, required: true },
    timestamp: { type: String, required: true },
    type: { type: String, enum: ['text', 'image'], required: true },
    receiver: { type: String, required: true },
    receiverDeviceId: { type: String, required: true },
    sender: { type: String, required: true },
    content: { type: String, required: true },
    spkId: { type: Number },
    opkId: { type: Number },
});
const MsgModel = mongoose.model('UnreadMsg', UnreadMsgSchema, 'unread_msgs');

module.exports = MsgModel;