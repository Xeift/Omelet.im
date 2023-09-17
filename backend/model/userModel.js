const mongoose = require('./mongoose');

const UserSchema = new mongoose.Schema({
    uid: { type: String, unique: true },
    timestamp: { type: Number },
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: { type: String },
    room_joined: { type: [String], default: [] },
    // reset_temp_code: { type: String },
});
const UserModel = mongoose.model('User', UserSchema, 'users');

module.exports = UserModel;