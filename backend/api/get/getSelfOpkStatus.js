const authController = require('../../controller/authController.js');
const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let decodedToken = req.decodedToken;
        let uid = decodedToken._uid;
        let ipkPub = req.query.ipkPub;

        console.log(`[getSelfOpkStatus.js]\nipkPub:${ipkPub}\nuid:${uid}`);

        let deviceId = await preKeyBundleController.findDeviceIdByIpkPub(uid, ipkPub);
        console.log('[getSelfOpkStatus.js] deviceId: ' + deviceId);
        let [outOfOpk, lastBatchMaxOpkId] = await preKeyBundleController.getSelfOpkStatus(uid, deviceId);

        res.status(200).json({
            message: '成功取得 OPK 狀態',
            data: { 'outOfOpk': outOfOpk, 'lastBatchMaxOpkId': lastBatchMaxOpkId },
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