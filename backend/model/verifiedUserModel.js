const mongoose = require('./mongoose');

const VerifiedUserSchema = new mongoose.Schema({
    uid: { type: String, unique: true },
    timestamp: { type: Number },
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: { type: String },
    lastDeviceId: { type: Number },
    friends: { type: [String], default: [] },
});
const VerifiedUserModel = mongoose.model('VerifiedUser', VerifiedUserSchema, 'verified_users');

module.exports = VerifiedUserModel;