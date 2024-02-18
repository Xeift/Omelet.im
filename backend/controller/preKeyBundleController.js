const PreKeyBundleModel = require('./../model/preKeyBundleModel');
const VerifiedUserModel = require('./../model/verifiedUserModel');


async function uploadPreKeyBundle(uid, ipkPub, spkPub, spkSig, opkPub) {
    let lastBatchSpkUpdateTime = Date.now();
    let lastBatchSpkId = ( Math.max(...Object.keys(spkPub).map(Number)) ).toString();
    let deviceId = (await getLastDeviceId(uid)) + 1;
    
    await PreKeyBundleModel.findOneAndUpdate(
        { uid: uid, deviceId: deviceId },
        { deviceId: deviceId, ipkPub: ipkPub, spkPub: spkPub, spkSig: spkSig, opkPub: opkPub, lastBatchMaxOpkId: Object.keys(opkPub)[Object.keys(opkPub).length - 1], lastBatchSpkUpdateTime: lastBatchSpkUpdateTime, lastBatchSpkId: lastBatchSpkId },
        { upsert: true }
    );
}

async function downloadMultiDevicesPreKeyBundle(uid, opkId) {
    // TODO: make download multi devices
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

async function getMultiDevicesAvailableOpkIndex(uid, isSelf, deviceId) {
    let multiDevicesPreKeyBundles = await PreKeyBundleModel.find(
        { uid: uid },
        'deviceId opkPub'
    ).lean();

    if (isSelf) {
        // remove current device (deviceId) from multiDevicesPreKeyBundles
        multiDevicesPreKeyBundles = multiDevicesPreKeyBundles.filter(bundle => bundle.deviceId !== deviceId);
        console.log(multiDevicesPreKeyBundles);
    }

    let multiDevicesAvailableOpkIndex = {};
    multiDevicesPreKeyBundles.forEach(bundle => {
        multiDevicesAvailableOpkIndex[bundle.deviceId] = Object.keys(bundle.opkPub);
    });

    return multiDevicesAvailableOpkIndex;
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

async function getSelfOpkStatus(uid, deviceId) {
    let opkStatus = await PreKeyBundleModel.findOne(
        { uid: uid, deviceId: deviceId },
        'opkPub lastBatchMaxOpkId'
    );
    let outOfOpk = Object.keys(opkStatus['opkPub']).length === 0;
    let lastBatchMaxOpkId = opkStatus['lastBatchMaxOpkId'];

    return [outOfOpk, lastBatchMaxOpkId];
}

async function getSelfSpkStatus(uid, deviceId) {
    let spkStatus = await PreKeyBundleModel.findOne(
        { uid: uid, deviceId: deviceId },
        'spkPub lastBatchSpkId lastBatchSpkUpdateTime'
    );
    let spkExpired = (Date.now() - spkStatus['lastBatchSpkUpdateTime']) >= (7 * 24 * 60 * 60 * 1000); // 7d
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

async function getLastDeviceId(uid) {
    let lastDeviceId = (await VerifiedUserModel.findOne(
        { uid: uid },
        'lastDeviceId',
    )).lastDeviceId;

    if (lastDeviceId === undefined) {
        lastDeviceId = -1; // last round deviceId
        await VerifiedUserModel.findOneAndUpdate( // this round deviceId, increment 1 after read
            { uid: uid },
            { lastDeviceId: 0 }
        );
    }
    else {
        await VerifiedUserModel.findOneAndUpdate( // this round deviceId, increment 1 after read
            { uid: uid },
            { lastDeviceId: lastDeviceId + 1 }
        );        
    }

    console.log(`[preKeyBundleController.js] lastDeviceId: ${lastDeviceId}`);
    return lastDeviceId;
}

async function findDeviceIdByIpkPub(uid, ipkPub) {
    let deviceId = (await PreKeyBundleModel.findOne(
        { uid: uid, ipkPub: ipkPub },
        'deviceId',
    )).deviceId;

    return deviceId;
}

module.exports = {
    uploadPreKeyBundle,
    downloadMultiDevicesPreKeyBundle,
    getMultiDevicesAvailableOpkIndex,
    deleteOpkPub,
    updateOpk,
    getSelfOpkStatus,
    getSelfSpkStatus,
    updateSpk,
    findDeviceIdByIpkPub
};