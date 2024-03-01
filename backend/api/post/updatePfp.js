const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;

    let pfpData = req.body.pfpData;
    console.log(pfpData);


    try {
        res.status(200).json({
            message: 'pfp 上傳成功',
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