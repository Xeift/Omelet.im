const snowflakeId = require('../utils/snowflakeId');
const UserModel = require('../model/userModel');

async function isPasswordMatch(username, password) {
    let user = await UserModel.findOne({ $or: [{ username: username }, { email: username }] });
    if (password === user.password) {
        return user;
    }
    else {
        return false;
    }
}

async function isUserIdExsists(input) {
    let uid = await UserModel.findOne({ uid: input });
    return !!uid;
}

async function isEmailExsists(input) {
    let email = await UserModel.findOne({ email: input });
    return !!email;
}

async function createNewUser(email, username, password) {
    let uid = snowflakeId.generateId();
    await UserModel.create({
        uid: uid,
        timestamp: snowflakeId.extractTimeStampFromId(uid),
        username: username,
        email: email,
        password: password,
    });
}

async function updatePasswordByEmail(email, newPassword) {
    const user = await UserModel.findOne({ email });
    user.password = newPassword;
    await user.save();
}

module.exports = {
    isPasswordMatch,
    isUserIdExsists,
    isEmailExsists,
    createNewUser,
    updatePasswordByEmail
};