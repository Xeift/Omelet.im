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
            res.json({ success: true });
        }
        else {
            res.json({ success: false });
        }
    }
    catch (err) {
        console.log(err);
        res.json({ success: false});
    }
};