const mongoose = require('./mongoose');

const UserSchema = new mongoose.Schema({
    uid: { type: String, unique: true },
    timestamp: { type: Number },
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: { type: String },
    room_joined: { type: [String], default: [] },
    ipkPub: { type: String, unique: true },
    spkPub: { type: mongoose.Schema.Types.Mixed, unique: true },
    spkSig: { type: mongoose.Schema.Types.Mixed, unique: true },
    opkPub: { type: mongoose.Schema.Types.Mixed, unique: true },
    lastBatchMaxOpkId: { type: Number },
});
const UserModel = mongoose.model('User', UserSchema, 'users');

module.exports = UserModel;