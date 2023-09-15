const mongoose = require('mongoose');
require('dotenv').config({ path: 'config/.env' });
const MONGO_URI = process.env.MONGO_URI;
const generateId = require('./generateId');

mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }); // 連接至 Mongodb

const UserSchema = new mongoose.Schema({ // 建立 UserSchema
    uid: { type: Number, unique: true },
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: { type: String }
    // reset_temp_code: { type: String },
});
const UserModel = mongoose.model('User', UserSchema); // 建立 UserModel

const RoomSchema = new mongoose.Schema({ // 建立 RoomSchema
    id: { type: String, unique: true },
    members: { type: Array }

});
const RoomModel = mongoose.model('Chat', RoomSchema); // 建立 RoomModel


async function isPasswordMatch(username, password) {
    try {
        let user = await UserModel.findOne({ username: username, password: password }) || await UserModel.findOne({ email: username, password: password });

        if (user) { // username or email match password
            return user;
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
        const user = await UserModel.findOne({ username: _username }); // TODO: FIX username or email Bug
        if (user) {
            return user.uid;
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

async function isEmailExsists(input) {
    try {
        if (await UserModel.findOne({ email: input })) {
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

async function createNewUser(email, username, password) {
    try {
        let updatedUser = await UserModel.create({
            uid: generateId(),
            email: email,
            username: username,
            password: password
        });

        if (updatedUser) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (err) {
        return `後端發生例外錯誤： ${err.message}`;
    }
}

async function updatePasswordByEmail(email, newPassword) {
    try {
        const user = await UserModel.findOne({ email });
        user.password = newPassword;
        await user.save();
        return true;
    }
    catch (error) {
        console.error('更新使用者密碼失敗:', error.message);
        return false;
    }
}

module.exports = { isPasswordMatch, findIdByUsername, isUserExsists, isEmailExsists, createNewUser, updatePasswordByEmail };