const mongoose = require('./mongoose');

const UnreadMsgSchema = new mongoose.Schema({
    timestamp: { type: String, required: true },
    type: { type: String, enum: ['text', 'image'], required: true },
    receiver: { type: String, required: true },
    sender: { type: String, required: true },
    content: { type: String, required: true },
    spkId: { type: Number },
    opkId: { type: Number },
});
const MsgModel = mongoose.model('UnreadMsg', UnreadMsgSchema, 'unreadmsgs');

module.exports = MsgModel;