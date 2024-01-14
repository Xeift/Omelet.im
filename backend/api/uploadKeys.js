const msgController = require('../controller/msgController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../utils/jwt.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    console.log(req.body);
    let deviceId = req.body.deviceId;
    let ipkPub = req.body.ipkPub;
    let spkPub = req.body.spkPub;
    let spkSig = req.body.spkSig;
    let opkPub = req.body.opkPub;

    // TODO: 上傳至 mdb


    try {
        res.status(200).json({
            message: '此 JWT 有效',
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