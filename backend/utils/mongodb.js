const mongoose = require('mongoose');
require('dotenv').config({ path: 'config/.env' });
const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }); // 連接至 Mongodb

const UserSchema = new mongoose.Schema({ // 建立 UserSchema
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: String,
    reset_temp_code: { type: String, unique: true },
});

const UserModel = mongoose.model('User', UserSchema); // 建立 UserModel

async function isPasswordMatch(username, password) {
    try {
        let user = await UserModel.findOne({ username: username, password: password }) || await UserModel.findOne({ email: username, password: password });

        if (user) { // username or email match password
            return true;
        }
        else { // username or email not match password
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

async function findIdByUsername(_username) {
    try {
        const user = await UserModel.findOne({ username: _username });
        if (user) {
            return user.id;
        }
        else {
            return false;
        }
    }
    catch (error) {
        console.error(error);
    }
}

async function isUserExsists(input) {
    try {
        if (await UserModel.findOne({ username: input }) || await UserModel.findOne({ email: input })) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

module.exports = { isPasswordMatch, findIdByUsername, isUserExsists };