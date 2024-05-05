const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const authController = require('../../controller/authController.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let uid = req.query.uid;
        let userPublicInfo = await authController.getUserPublicInfoByUid(uid);
        
        res.status(200).json({
            message: '成功取得使用者公開資訊',
            data: userPublicInfo,
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