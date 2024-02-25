const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const msgController = require('../../controller/msgController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let decodedToken = req.decodedToken;
        let uid = decodedToken._uid;
        let ipkPub = req.query.ipkPub;

        let deviceId = await preKeyBundleController.findDeviceIdByIpkPub(uid, ipkPub);
        let msg = await msgController.readUnreadMsg(uid, deviceId);

        res.status(200).json({
            message: '成功讀取未讀訊息',
            data: msg,
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