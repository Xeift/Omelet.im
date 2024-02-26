const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;

    let ipkPub = req.body.ipkPub;
    let deviceId = await preKeyBundleController.findDeviceIdByIpkPub(ourUid, ipkPub);
    let opkPub = JSON.parse(req.body.opkPub);

    await preKeyBundleController.updateOpk(ourUid, deviceId, opkPub);


    try {
        res.status(200).json({
            message: 'opk 上傳成功',
            data: null,
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