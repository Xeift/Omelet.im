const express = require('express');
const router = express.Router();
const jwt = require('../utils/jwt.js');
const preKeyBundleController = require('../controller/preKeyBundleController.js');

router.post('/', async(req, res) => {

    await preKeyBundleController.debugResetPreKeyBundle();

    try {
        res.status(200).json({
            message: '已刪除所有未讀訊息及PreKeyBundle，deviceId 已重置',
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