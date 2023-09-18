const snowflakeId = require('../utils/snowflakeId');
const UserModel = require('../model/userModel');

async function isPasswordMatch(username, password) {
    try {
        let user = await UserModel.findOne({ username: username, password: password }) || await UserModel.findOne({ email: username, password: password });
        if (user) {
            return user;
        }
        else {
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

async function isUserIdExsists(input) {
    try {
        if (await UserModel.findOne({ uid: input })) {
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
        let uid = snowflakeId.generateId();
        let updatedUser = await UserModel.create({
            uid: uid,
            timestamp: snowflakeId.extractTimeStampFromId(uid),
            username: username,
            email: email,
            password: password,
        });
        console.log(`[authController.js] updatedUser: ${updatedUser}`);
        if (updatedUser) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (err) {
        if(err.code === 11000) {
            return '使用者名稱或 email 不可重複';
        }
        else {
            return `後端發生例外錯誤： ${err.message}`;
        }
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

module.exports = {
    isPasswordMatch,
    isUserIdExsists,
    isEmailExsists,
    createNewUser,
    updatePasswordByEmail
};