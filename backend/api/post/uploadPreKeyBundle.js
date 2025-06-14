const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const friendController = require('../../controller/friendController.js');
const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const eventEmitter = require('../../utils/eventEmitter.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let uid = decodedToken._uid;

    let ipkPub = req.body.ipkPub;
    let spkPub = JSON.parse(req.body.spkPub);
    
    let spkSig = JSON.parse(req.body.spkSig);
    let opkPub = JSON.parse(req.body.opkPub);

    let deviceId = await preKeyBundleController.uploadPreKeyBundle(uid, ipkPub, spkPub, spkSig, opkPub);

    try {
        let friendUidList = await friendController.getFriendsList(uid);
        let ourDeviceIds = await preKeyBundleController.getOurDeviceIds(uid);
        eventEmitter.emit('friendsDevicesUpdatedJs', { friendUid: uid, friendNewDevicesIds: ourDeviceIds, target: friendUidList });

        res.status(200).json({
            message: '上傳成功',
            data: { deviceId: deviceId },
            token: null
        });
    }
    catch (err) {
        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
    }
});

module.exports = router;