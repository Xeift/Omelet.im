const PreKeyBundleModel = require('../model/preKeyBundleModel');
const VerifiedUserModel = require('../model/verifiedUserModel');
const MsgModel = require('../model/msgModel');


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

async function downloadMultiDevicesPreKeyBundle(uid, opkIds) {
    let allPreKeyBundle = {};

    for (let [deviceId, opkId] of Object.entries(opkIds)) {
        console.log(`[preKeyController.js] ${deviceId}   ${opkId}`);

        let pkb = await PreKeyBundleModel.findOne(
            { uid: uid, deviceId: deviceId },
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
    
        allPreKeyBundle[deviceId] = newPreKeyBundle;
    }

    return allPreKeyBundle;
}

async function getMultiDevicesAvailableOpkIndex(uid, isSelf, deviceId) {
    let multiDevicesPreKeyBundles = await PreKeyBundleModel.find(
        { uid: uid },
        'deviceId opkPub'
    ).lean();

    if (isSelf) {
        // 從 multiDevicesPreKeyBundles 移除目前裝置的 deviceId
        // 避免發送訊息給自己
        multiDevicesPreKeyBundles = multiDevicesPreKeyBundles.filter(bundle => bundle.deviceId !== deviceId);
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

async function updateOpk(uid, deviceId, opkPub) {
    await PreKeyBundleModel.findOneAndUpdate(
        { uid: uid, deviceId: deviceId },
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

async function updateSpk(uid, deviceId, spkPub, spkSig) {
    await PreKeyBundleModel.updateOne(
        { uid: uid, deviceId: deviceId }, {
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
    try {
        let deviceId = (await PreKeyBundleModel.findOne(
            { uid: uid, ipkPub: ipkPub },
            'deviceId',
        )).deviceId;
        
        return deviceId;
    }
    catch (error) {
        console.log(error);
    }
}

async function debugResetPreKeyBundle() {
    console.log('preKeyBundleController.js--------------------------------');
    await PreKeyBundleModel.deleteMany({});
    console.log('所有PreKeyBundleModel的document已被刪除');
    await VerifiedUserModel.updateMany({}, { $unset: { lastDeviceId: 1 } });
    console.log('VerifiedUserModel中所有document的deviceId欄位已被刪除');
    await MsgModel.deleteMany({});
    console.log('所有UnreadMsg的document已被刪除');
    console.log('preKeyBundleController.js--------------------------------');
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
    findDeviceIdByIpkPub,
    debugResetPreKeyBundle
};