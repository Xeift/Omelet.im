const mongoose = require('./mongoose');

const UnverifiedUserSchema = new mongoose.Schema({
    uid: { type: String, unique: true },
    timestamp: { type: Number },
    username: { type: String },
    email: { type: String },
    password: { type: String },
});
const UnverifiedUserModel = mongoose.model('UnverifiedUser', UnverifiedUserSchema, 'unverified_users');

module.exports = UnverifiedUserModel;