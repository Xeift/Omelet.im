const PreKeyBundleModel = require('./../model/preKeyBundleModel');


async function uploadPreKeyBundle(uid, ipkPub, spkPub, spkSig, opkPub) {
    let lastBatchSpkUpdateTime = Date.now();
    let lastBatchSpkId = ( Math.max(...Object.keys(spkPub).map(Number)) ).toString();

    await PreKeyBundleModel.findOneAndUpdate(
        { uid: uid },
        { ipkPub: ipkPub, spkPub: spkPub, spkSig: spkSig, opkPub: opkPub, lastBatchMaxOpkId: Object.keys(opkPub)[Object.keys(opkPub).length - 1], lastBatchSpkUpdateTime: lastBatchSpkUpdateTime, lastBatchSpkId: lastBatchSpkId },
        { upsert: true, new: true }
    );
}

async function downloadPreKeyBundle(uid, opkId) {
    let pkb = await PreKeyBundleModel.findOne(
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
    return Object.keys((await PreKeyBundleModel.findOne(
        { uid: uid },
        'opkPub'
    )).opkPub);
}

async function deleteOpkPub(uid, opkId) {
    let result = await PreKeyBundleModel.updateOne(
        { uid: uid },
        { $unset: { [`opkPub.${opkId}`]: true } }
    );
    return result;
}

async function updateOpk(uid, opkPub) {
    await PreKeyBundleModel.findOneAndUpdate(
        { uid: uid },
        { opkPub: opkPub, lastBatchMaxOpkId: Object.keys(opkPub)[Object.keys(opkPub).length - 1] }
    );
}

async function getSelfOpkStatus(uid) {
    let opkStatus = await PreKeyBundleModel.findOne(
        { uid: uid },
        'opkPub lastBatchMaxOpkId'
    );
    let outOfOpk = Object.keys(opkStatus['opkPub']).length === 0;
    let lastBatchMaxOpkId = opkStatus['lastBatchMaxOpkId'];

    return [outOfOpk, lastBatchMaxOpkId];
}

async function getSelfSpkStatus(uid) {
    let spkStatus = await PreKeyBundleModel.findOne(
        { uid: uid },
        'spkPub lastBatchSpkId lastBatchSpkUpdateTime'
    );
    let spkExpired = (Date.now() - spkStatus['lastBatchSpkUpdateTime']) >= (7 * 24 * 60 * 60 * 1000);
    let lastBatchSpkId = spkStatus['lastBatchSpkId'];

    return [spkExpired, lastBatchSpkId];
}

async function updateSpk(uid, spkPub, spkSig) {
    await PreKeyBundleModel.updateOne(
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
    uploadPreKeyBundle,
    downloadPreKeyBundle,
    getAvailableOpkIndex,
    deleteOpkPub,
    updateOpk,
    getSelfOpkStatus,
    getSelfSpkStatus,
    updateSpk
};