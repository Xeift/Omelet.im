const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');
const multer  = require('multer');
const upload = multer({ dest: 'uploads/' });
const fs = require('fs');

router.post('/', jwt.verifyJWT, upload.single('pfpData'), async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;

    let pfpData = req.file; // multer 會將上傳的檔案放在 req.file
    let img = fs.readFileSync(pfpData.path);
    let encodedImage = img.toString('base64');
    await authController.updatePfpByUid(ourUid, encodedImage);

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