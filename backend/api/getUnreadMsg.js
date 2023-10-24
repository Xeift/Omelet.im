const msgController = require('../controller/msgController.js');
const express = require('express');
const router = express.Router();
const verifyJWT = require('./../utils/verifyJWT.js');

router.get('/', verifyJWT.verifyToken, async(req, res) => {

    try {
        console.log(req.decodedToken); // jwt
        res.status(200).json({
            message: '測試',
            data: null,
            // token: res
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