const express = require('express');
const mdb = require('../config/mongodb.js');
const auth = require('../config/auth.js');
const email = require('../utils/email.js');


module.exports = async (req, res) => {
    let emailData = req.body.email;

    try {
        let isEmailExsists = await mdb.isEmailExsists(emailData);
        if (!isEmailExsists) { 
            let code = await auth.generateRestorePasswordToken(emailData);
            let resetTempCodeStats = await mdb.saveRegisterTempCode(emailData, code);
            let emailStats = await email.sendRegisterMail(emailData, code);
            console.log(resetTempCodeStats);
            if (resetTempCodeStats !== true) {
                res.status(500).json({
                    message: '資料庫異常',
                    data: null,
                    token: null
                });
            }
            else if (emailStats !== true) {
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
        // res.status(500).json({
        //     message: `後端發生例外錯誤： ${err.message}`,
        //     data: null,
        //     token: null
        // });
        console.log(err);
    }
};