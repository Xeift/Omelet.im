const snowflakeId = require('./../../utils/snowflakeId.js');
const authController = require('../../controller/authController.js');
const jwt = require('../../utils/jwt.js');
const email = require('../../utils/email.js');
const express = require('express');
const router = express.Router();

router.post('/send-mail', async(req, res) => {
    let emailData = req.body.email;
    let usernameData = req.body.username;
    let passwordData = req.body.password;

    if (!emailData) {
        res.status(422).json({
            message: 'email輸入不可為空',
            data: null,
            token: null
        });
        return;
    }

    try {
        let isEmailVerified = await authController.isEmailVerified(emailData);

        if (isEmailVerified) { 
            res.status(409).json({
                message: '此 email 已存在，請登入',
                data: null,
                token: null
            });   
        }
        else {
            let uid = snowflakeId.generateId();
            let code = await jwt.generateRegisterJWT(uid, emailData);
            await authController.createNewUnverifiedUser(uid, emailData, usernameData, passwordData);
            await email.sendRegisterMail(emailData, code);

            res.status(200).json({
                message: '驗證 email 已成功寄出',
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

router.post('/submit-info', async(req, res) => {
    try {
        const { code, username, password } = req.body;
        const decoded = await jwt.verifyJWT(code);

        await authController.createNewUser(decoded.email, username, password);
        res.status(200).json({
            message: '註冊成功',
            data: null,
            token: null
        });
    }
    catch (err) {
        if(err.code === 11000) {
            res.status(409).json({
                message: '使用者名稱或 email 不可重複',
                data: null,
                token: null
            });
        }
        else {
            res.status(500).json({
                message: `後端發生例外錯誤： ${err.message}`,
                data: null,
                token: null
            });
        }
    }
});

module.exports = router;