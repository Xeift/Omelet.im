const authController = require('../../controller/authController.js');
const msgController = require('../../controller/msgController.js');
const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let uid = decodedToken._uid;

    let deviceId = req.body.deviceId;
    let ipkPub = req.body.ipkPub;
    let spkPub = JSON.parse(req.body.spkPub);
    
    let spkSig = JSON.parse(req.body.spkSig);
    let opkPub = JSON.parse(req.body.opkPub);

    await preKeyBundleController.uploadPreKeyBundle(uid, ipkPub, spkPub, spkSig, opkPub);

    try {
        res.status(200).json({
            message: '上傳成功',
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