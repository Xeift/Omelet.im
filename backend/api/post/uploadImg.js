const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');
const multer  = require('multer');
const fs = require('fs');
if (!fs.existsSync('img')){
    fs.mkdirSync('img');
}

const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        cb(null, 'img');
    },
    filename: function(req, file, cb) {
        let decodedToken = req.decodedToken;
        let ourUid = decodedToken._uid;
        cb(null, `${ourUid}.png`);
    }
});
const upload = multer({ storage: storage });

router.post('/', jwt.verifyJWT, upload.single('imgData'), async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    let receiverUid = req.body.receiverUid;
    let deviceId = req.body.deviceId;
    console.log(`[uploadImg.js] 接收者 id：${receiverUid}`);
    console.log(`[uploadImg.js] 裝置 id：${deviceId}`);

    try {
        res.status(200).json({
            message: '圖片上傳成功',
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