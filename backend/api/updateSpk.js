const authController = require('../controller/authController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../utils/jwt.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let uid = decodedToken._uid;

    let deviceId = req.body.deviceId;
    let spkPub = JSON.parse(req.body.spkPub);
    let spkSig = JSON.parse(req.body.spkSig);

    console.log('🧧--------------------------');
    console.log(spkPub);
    console.log(spkSig);
    await authController.updateSpk(uid, spkPub, spkSig);
    console.log('🧧--------------------------');


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