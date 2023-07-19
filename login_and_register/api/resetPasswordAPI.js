const express = require('express');
const mdb = require('../config/mongodb.js');
const auth = require('../config/auth.js');
const email = require('../utils/email.js');


module.exports = async (req, res) => {
    let emailData = req.body.email;
    console.log('resetpwd');
    try {
        let isEmailExsists = await mdb.isEmailExsists(emailData);
        if (isEmailExsists) { 
            const code = await auth.generateRestorePasswordToken(emailData);
            await mdb.saveResetTempCode(emailData, code);
            await email.sendMail(emailData, code);
            res.status(200).json({
                message: 'email 已成功寄出',
                data: null,
                token: null
            });
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
};