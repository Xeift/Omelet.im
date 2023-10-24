const messageController = require('../controller/msgController');
const authController = require('../controller/authController.js');
const jwt = require('../utils/jwt.js');
const email = require('../utils/email.js');
const express = require('express');
const router = express.Router();

router.post('/create-room', async(req, res) => {
    try {
        const { code, name, type } = req.body;
        const decoded = await jwt.verifyJWT(code);
        if (await authController.isUserIdExsists(decoded.uid)) {
            let updateStatus = await messageController.createNewRoom(name, type);
            if (updateStatus) {
                res.status(200).json({
                    message: 'room 建立成功',
                    data: null,
                    token: null
                });
            }
            else {
                res.status(500).json({
                    message: '資料庫異常',
                    data: null,
                    token: null
                });
            }
        }
        else {
            res.status(401).json({
                message: '驗證失敗',
                data: null,
                token: null
            });            
        }

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