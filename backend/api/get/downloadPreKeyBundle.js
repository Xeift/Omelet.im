const authController = require('../../controller/authController.js');
const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let uid = req.query.uid;
        let opkId = req.query.opkId;
        let preKeyBundle = await preKeyBundleController.downloadMultiDevicesPreKeyBundle(uid, opkId);

        res.status(200).json({
            message: '成功下載 Pre Key Bundle',
            data: preKeyBundle,
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