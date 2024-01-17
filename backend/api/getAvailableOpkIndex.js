const authController = require('../controller/authController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../utils/jwt.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let uid = req.query.uid;
        let preKeyBundle = await authController.getAvailableOpkIndex(uid);
        res.status(200).json({
            message: '成功取得 Pre Key Index',
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