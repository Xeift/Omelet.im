const msgController = require('../controller/msgController.js');
const express = require('express');
const router = express.Router();
const verifyJWT = require('../utils/verifyJWT.js');

router.post('/', verifyJWT.verifyToken, async(req, res) => {
    try {
        res.status(200).json({
            message: '此 JWT 有效',
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