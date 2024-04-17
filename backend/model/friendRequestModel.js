const mongoose = require('./mongoose');

const FriendRequestSchema = new mongoose.Schema({
    initiatorUid: { type: String },
    targetUid: { type: String },
    timestamp: { type: Number },
    type: { type: String },
});
const FriendRequestModel = mongoose.model('FriendRequest', FriendRequestSchema, 'friend_request');

module.exports = FriendRequestModel;