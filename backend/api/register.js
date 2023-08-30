const mdb = require('../utils/mongodb.js');
const jwt = require('../utils/jwt.js');
const email = require('../utils/email.js');
const express = require('express');
const router = express.Router();

router.post('/send-mail', async(req, res) => {
    let emailData = req.body.email;

    if (!emailData) {
        res.status(422).json({
            message: 'email輸入不可為空',
            data: null,
            token: null
        });
        return;
    }
    try {
        let isEmailExsists = await mdb.isEmailExsists(emailData);
        if (!isEmailExsists) { 
            let code = await jwt.generateRestorePasswordJWT(emailData);
            let emailStats = await email.sendRegisterMail(emailData, code);
            if (emailStats !== true) {
                res.status(500).json({
                    message: 'email 寄送失敗',
                    data: null,
                    token: null
                });                
            }
            else {
                res.status(200).json({
                    message: 'email 已成功寄出',
                    data: null,
                    token: null
                });
            }

        }
        else {
            res.status(401).json({
                message: 'email 已存在',
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
        console.log(err);
    }
});

module.exports = router;