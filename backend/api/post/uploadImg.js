const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');
const eventEmitter = require('../../utils/eventEmitter.js');
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
        let receiver = req.body.receiver;
        let receiverDeviceId = req.body.receiverDeviceId;
        let filename = req.body.content;


        cb(null, `${receiver}_${receiverDeviceId}_${filename}.png`);
    }
});
const upload = multer({ storage: storage });

router.post('/', jwt.verifyJWT, upload.single('imgData'), async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    let timestamp = Date.now().toString();
    let isPreKeySignalMessage = JSON.parse(req.body.isPreKeySignalMessage);
    let type = req.body.type;
    let sender = req.body.sender;
    let senderDeviceId = req.body.senderDeviceId;
    let receiver = req.body.receiver;
    let receiverDeviceId = req.body.receiverDeviceId;
    let filename = req.body.content;

    console.log(`ourUid：${ourUid}`);
    
    console.log(`isPreKeySignalMessage：${isPreKeySignalMessage}`);
    console.log(`type：${type}`);
    console.log(`sender：${sender}`);
    console.log(`receiver：${receiver}`);
    console.log(`receiverDeviceId：${receiverDeviceId}`);
    console.log(`filename：${filename}`);

    eventEmitter.emit('newImgUploadedJs', {
        isPreKeySignalMessage: isPreKeySignalMessage,
        type: type,
        sender: sender,
        senderDeviceId: senderDeviceId,
        receiver: receiver,
        receiverDeviceId: receiverDeviceId,
        content: `${receiver}_${receiverDeviceId}_${filename}.png`,
    });

    console.log('[uploadImg] 圖片已上傳');

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