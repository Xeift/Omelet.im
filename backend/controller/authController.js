const snowflakeId = require('../utils/snowflakeId');
const UserModel = require('../model/verifiedUserModel');
const UnverifiedUserModel = require('../model/unverifiedUserModel');
const VerifiedUserModel = require('./../model/verifiedUserModel');

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

async function isEmailVerified(input) {
    let email = await UserModel.findOne({ email: input });
    return !!email;
}

async function createNewUnverifiedUser(uid, email, username, password) {
    await UnverifiedUserModel.create({
        uid: uid,
        timestamp: snowflakeId.extractTimeStampFromId(uid),
        username: username,
        email: email,
        password: password,
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
    const user = await UserModel.findOne({ email });
    user.password = newPassword;

    await user.save();
}

async function uploadPreKeyBundle(uid, ipkPub, spkPub, spkSig, opkPub) {
    let lastBatchSpkUpdateTime = Date.now();
    let lastBatchSpkId = ( Math.max(...Object.keys(spkPub).map(Number)) ).toString();

    await UserModel.findOneAndUpdate(
        { uid: uid },
        { ipkPub: ipkPub, spkPub: spkPub, spkSig: spkSig, opkPub: opkPub, lastBatchMaxOpkId: Object.keys(opkPub)[Object.keys(opkPub).length - 1], lastBatchSpkUpdateTime: lastBatchSpkUpdateTime, lastBatchSpkId: lastBatchSpkId }
    );
}

async function downloadPreKeyBundle(uid, opkId) {
    let pkb = await UserModel.findOne(
        { uid: uid },
        'ipkPub spkPub spkSig opkPub'
    ).lean();
    let latestSpkIndex = ( Math.max(...Object.keys(pkb['spkPub']).map(Number)) ).toString();
    let newPreKeyBundle = {};

    newPreKeyBundle['ipkPub'] = pkb['ipkPub'];

    newPreKeyBundle['spkId'] = latestSpkIndex;
    newPreKeyBundle['spkPub'] = pkb['spkPub'][latestSpkIndex];
    newPreKeyBundle['spkSig'] = pkb['spkSig'][latestSpkIndex];

    newPreKeyBundle['opkId'] = opkId;
    newPreKeyBundle['opkPub'] = pkb['opkPub'][opkId];

    return newPreKeyBundle;
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

async function getSelfSpkStatus(uid) {
    let spkStatus = await UserModel.findOne(
        { uid: uid },
        'spkPub lastBatchSpkId lastBatchSpkUpdateTime'
    );
    let spkExpired = (Date.now() - spkStatus['lastBatchSpkUpdateTime']) >= (7 * 24 * 60 * 60 * 1000);
    let lastBatchSpkId = spkStatus['lastBatchSpkId'];

    return [spkExpired, lastBatchSpkId];
}

async function updateSpk(uid, spkPub, spkSig) {
    await UserModel.updateOne(
        { uid: uid }, {
            $set: {
                [`spkPub.${Object.keys(spkPub)}`]: spkPub, 
                [`spkSig.${Object.keys(spkSig)}`]: spkSig,
                lastBatchSpkId: parseInt(Object.keys(spkPub)),
                lastBatchSpkUpdateTime: Date.now()
            }
        }
    );
}

module.exports = {
    isPasswordMatch,
    isUserIdExsists,
    isEmailVerified,
    createNewUnverifiedUser,
    makeUnverifiedUserVerified,
    updatePasswordByEmail,
    uploadPreKeyBundle,
    downloadPreKeyBundle,
    getAvailableOpkIndex,
    deleteOpkPub,
    updateOpk,
    getSelfOpkStatus,
    getSelfSpkStatus,
    updateSpk
};