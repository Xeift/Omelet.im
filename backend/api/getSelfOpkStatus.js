const authController = require('../controller/authController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../utils/jwt.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let decodedToken = req.decodedToken;
        let uid = decodedToken._uid;
        let [outOfOpk, lastBatchMaxOpkId] = await authController.getSelfOpkStatus(uid);
        console.log(`outOfOpk: ${outOfOpk}`);
        console.log(`lastBatchMaxOpkId: ${lastBatchMaxOpkId}`);
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