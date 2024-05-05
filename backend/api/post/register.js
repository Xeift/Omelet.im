
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const email = require('../../utils/email.js');
const snowflakeId = require('./../../utils/snowflakeId.js');
const authController = require('../../controller/authController.js');

router.post('/send-mail', async(req, res) => {
    let emailData = req.body.email;
    let usernameData = req.body.username;
    let passwordData = req.body.password;

    if (!emailData) {
        res.status(422).json({
            message: 'email 不可為空',
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

module.exports = router;