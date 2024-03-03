const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');
const multer  = require('multer');
const fs = require('fs');
if (!fs.existsSync('./uploads')){
    fs.mkdirSync('./uploads');
}

const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        cb(null, 'uploads/');
    },
    filename: function(req, file, cb) {
        let decodedToken = req.decodedToken;
        let ourUid = decodedToken._uid;
        cb(null, `${ourUid}.png`);
    }
});
const upload = multer({ storage: storage });

router.post('/', jwt.verifyJWT, upload.single('pfpData'), async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    await authController.updatePfpStatus(ourUid, true);

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