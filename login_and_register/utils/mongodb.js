const mongoose = require('mongoose');
require('dotenv').config();
const MONGO_URI = process.env.MONGO_URI;


mongoose.connect(MONGO_URI, {useNewUrlParser: true, useUnifiedTopology: true}); // connect to mongodb

const UserSchema = new mongoose.Schema({
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: String,
    reset_temp_code: { type: String, unique: true },
});
const UserModel = mongoose.model('User', UserSchema);


const UnverifiedUserSchema = new mongoose.Schema({
    email: { type: String, unique: true },
    reset_temp_code: { type: String, unique: true },
});
const UnverifiedUserModel = mongoose.model('UnverifiedUser', UnverifiedUserSchema);

async function isUserExsists(input) {
    try {
        if (await UserModel.findOne({username: input}) || await UserModel.findOne({email: input})) { // username or email exsists
            return true;
        }
        else { // username or email not exsists
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}


async function isEmailExsists(input) {
    try {
        if (await UserModel.findOne({email: input})) { // email exsists
            return true;
        }
        else { // email not exsists
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}


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


async function register(username, email, password ) {
    try {
        UserModel.create({ username, email, password });
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
};


async function saveResetTempCode(email, newResetTempCode) {
    try {
        const updatedUser = await UserModel.findOneAndUpdate({ email: email }, { reset_temp_code: newResetTempCode }, { new: true });
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


async function saveRegisterTempCode(email, newResetTempCode) {
    try {
        const existingUser = await UnverifiedUserModel.findOne({ email });
        let updatedUser;
        if (existingUser) {
            existingUser.reset_temp_code = newResetTempCode;
            updatedUser = await existingUser.save();
        }
        else {
            updatedUser = await UnverifiedUserModel.create({ email: email, reset_temp_code: newResetTempCode });
        }

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
        console.log('new');
        console.log(newPassword);
        const user = await UserModel.findOne({ email });
        user.password = newPassword;
        await user.save();
        console.log('使用者密碼更新成功');
        return true;
    }
    catch (error) {
        console.error('更新使用者密碼失敗:', error.message);
        return false;
    }
}

async function createNewUser(email, username, password) {
    try {
        updatedUser = await UserModel.create({ email: email, username: username, password: password });


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

module.exports = { isUserExsists, isEmailExsists, isPasswordMatch, register, findIdByUsername, saveResetTempCode, saveRegisterTempCode, updatePasswordByEmail, createNewUser }