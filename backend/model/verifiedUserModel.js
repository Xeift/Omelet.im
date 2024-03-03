const { boolean } = require('webidl-conversions');
const mongoose = require('./mongoose');

const VerifiedUserSchema = new mongoose.Schema({
    uid: { type: String, unique: true },
    timestamp: { type: Number },
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: { type: String },
    room_joined: { type: [String], default: [] },
    hasPfp: { type: Boolean, default: false },
    lastDeviceId: { type: Number },
});
const VerifiedUserModel = mongoose.model('VerifiedUser', VerifiedUserSchema, 'verified_users');

module.exports = VerifiedUserModel;