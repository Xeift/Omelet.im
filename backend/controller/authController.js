const snowflakeId = require('../utils/snowflakeId');
const UserModel = require('../model/userModel');

async function isPasswordMatch(username, password) {
    let user = await UserModel.findOne({
        $or: [
            { username: username },
            { email: username }
        ]
    });
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

async function uploadPreKeyBundle(uid, ipkPub, spkPub, spkSig, opkPub) {
    let timestamp = Date.now().toString();
    await UserModel.findOneAndUpdate(
        { uid: uid },
        { ipkPub: ipkPub, spkPub: spkPub, spkSig: spkSig, opkPub: opkPub, lastBatchMaxOpkId: Object.keys(opkPub)[Object.keys(opkPub).length - 1], lastSpkUpdateTime: timestamp }
    );
}

async function downloadPreKeyBundle(uid, opkId) {
    let pkb = await UserModel.findOne(
        { uid: uid },
        'ipkPub spkPub spkSig opkPub'
    );

    pkb._doc['opkId'] = opkId;
    pkb['opkPub'] = pkb['opkPub'][opkId];

    let latestSpkIndex = ( Math.max(...Object.keys(JSON.parse(pkb['spkPub'])).map(Number)) ).toString();
    pkb._doc['spkId'] = latestSpkIndex;
    pkb['spkPub'] = JSON.parse(pkb['spkPub'])[latestSpkIndex];
    pkb['spkSig'] = JSON.parse(pkb['spkSig'])[latestSpkIndex];
    
    return pkb;
}

async function getAvailableOpkIndex(uid) {
    return Object.keys((await UserModel.findOne(
        { uid: uid },
        'opkPub'
    )).opkPub);
}

async function deleteOpkPub(uid, opkId) {
    let result = await UserModel.updateOne(
        { uid: uid },
        { $unset: { [`opkPub.${opkId}`]: true } }
    );
    return result;
}

async function updateOpk(uid, opkPub) {
    await UserModel.findOneAndUpdate(
        { uid: uid },
        { opkPub: opkPub, lastBatchMaxOpkId: Object.keys(opkPub)[Object.keys(opkPub).length - 1] }
    );
}

async function getSelfOpkStatus(uid) {
    let opkStatus = await UserModel.findOne(
        { uid: uid },
        'opkPub lastBatchMaxOpkId'
    );
    let outOfOpk = Object.keys(opkStatus['opkPub']).length === 0;
    let lastBatchMaxOpkId = opkStatus['lastBatchMaxOpkId'];

    return [outOfOpk, lastBatchMaxOpkId];
}

module.exports = {
    isPasswordMatch,
    isUserIdExsists,
    isEmailExsists,
    createNewUser,
    updatePasswordByEmail,
    uploadPreKeyBundle,
    downloadPreKeyBundle,
    getAvailableOpkIndex,
    deleteOpkPub,
    updateOpk,
    getSelfOpkStatus
};