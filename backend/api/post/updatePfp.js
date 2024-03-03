const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');
const multer  = require('multer');
const upload = multer();
const fs = require('fs');

router.post('/', jwt.verifyJWT, upload.single('pfpData'), async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;

    const imageBase64 = Buffer.from(req.file.buffer).toString('base64');
    await authController.updatePfpByUid(ourUid, imageBase64);

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