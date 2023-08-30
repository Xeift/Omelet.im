const mdb = require('../utils/mongodb.js');
const jwt = require('../utils/jwt.js');
const email = require('../utils/email.js');
const express = require('express');
const router = express.Router();

router.post('/send-mail', async(req, res) => {
    let emailData = req.body.email;

    try {
        let isEmailExsists = await mdb.isEmailExsists(emailData);
        if (isEmailExsists) { 
            let code = await jwt.generateRestorePasswordJWT(emailData);
            let emailStats = await email.sendResetPasswordMail(emailData, code);

            if (emailStats === true) {
                res.status(200).json({
                    message: 'email 已成功寄出',
                    data: null,
                    token: null
                });
            }
            else {
                res.status(500).json({
                    message: 'email 寄送失敗',
                    data: null,
                    token: null
                });                
            }
        }
        else {
            res.status(401).json({
                message: 'email 不存在',
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