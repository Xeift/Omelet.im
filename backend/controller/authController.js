const snowflakeId = require('../utils/snowflakeId');
const passwordHelper = require('../utils/passwordHelper');
const VerifiedUserModel = require('../model/verifiedUserModel');
const UnverifiedUserModel = require('../model/unverifiedUserModel');
require('dotenv').config({ path: 'config/.env' });
const AWS_SERVER_URI = process.env.AWS_SERVER_URI;
const fs = require('fs');
const path = require('path');

async function isPasswordMatch(username, password) {
    let user = await VerifiedUserModel.findOne({
        $or: [
            { username: username },
            { email: username }
        ]
    });
    if (await passwordHelper.checkPassword(password, user.password)) {
        return user;
    }
    else {
        return false;
    }
}

async function isUserIdExsists(input) {
    let uid = await VerifiedUserModel.findOne({ uid: input });
    return !!uid;
}

async function isEmailVerified(input) {
    let email = await VerifiedUserModel.findOne({ email: input });
    return !!email;
}

async function createNewUnverifiedUser(uid, email, username, password) {
    let hashedPassword = await passwordHelper.hashPassword(password);

    await UnverifiedUserModel.create({
        uid: uid,
        timestamp: snowflakeId.extractTimeStampFromId(uid),
        username: username,
        email: email,
        password: hashedPassword,
    });
}

async function createNewVerifiedUser(uid, timestamp, username, email, password) {
    await VerifiedUserModel.create({
        uid: uid,
        timestamp: timestamp,
        username: username,
        email: email,
        password: password,
    });
}

async function removeUnverifiedUserByEmail(email) {
    await UnverifiedUserModel.deleteMany({ email: email });
}

async function makeUnverifiedUserVerified(uid, email) {
    let unverifiedUser = await UnverifiedUserModel.findOne({ uid: uid });

    await createNewVerifiedUser(
        uid,
        unverifiedUser.timestamp,
        unverifiedUser.username,
        email,
        unverifiedUser.password
    );

    await removeUnverifiedUserByEmail(email);
}

async function updatePasswordByEmail(email, newPassword) {
    const user = await VerifiedUserModel.findOne({ email });
    let hashedNewPassword = await passwordHelper.hashPassword(newPassword);
    user.password = hashedNewPassword;

    await user.save();
}

async function updatePfpStatus(uid, hasPfp) {
    const user = await VerifiedUserModel.findOne({ uid: uid });
    user.hasPfp = hasPfp;

    await user.save();
}

async function getUserPublicInfoByUid(uid) {
    let userInfo = await VerifiedUserModel.findOne({ uid: uid });
    let pfpExsist = fs.existsSync(path.join(__dirname, 'pfp', `${uid}.png`));

    let pfp;
    if (pfpExsist) {
        pfp = `${AWS_SERVER_URI}pfp/${uid}.png`;
    }
    else {
        pfp = null;
    }
    let userPublicInfo = { username: userInfo['username'], pfp: pfp };
    console.log(userPublicInfo);
    return userPublicInfo;
}

async function getUidByEmail(email) {
    let user = await VerifiedUserModel.findOne({ email: email });
    return user ? user.uid : null;
}

async function getUidByUsername(username) {
    let user = await VerifiedUserModel.findOne({ username: username });
    return user ? user.uid : null;
}

module.exports = {
    isPasswordMatch,
    isUserIdExsists,
    isEmailVerified,
    createNewUnverifiedUser,
    makeUnverifiedUserVerified,
    updatePasswordByEmail,
    updatePfpStatus,
    getUserPublicInfoByUid,
    getUidByEmail,
    getUidByUsername
};