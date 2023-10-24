// const authController = require('../controller/msgController.js');
const express = require('express');
const router = express.Router();

router.get('/', async(req, res) => {

    try {
        res.status(200).json({
            message: '測試',
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