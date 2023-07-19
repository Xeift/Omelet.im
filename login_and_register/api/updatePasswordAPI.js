const express = require('express');
const path = require('path');
const jwt = require('jsonwebtoken');
const auth = require('../config/auth')
const mdb = require('../config/mongodb.js');


module.exports = async (req, res) => {
    try {
        const { code, password } = req.body;
        const decoded = jwt.verify(code, 'your-secret-key');
        console.log(decoded);
        console.log(decoded.email);

        if (await mdb.isEmailExsists(decoded.email)) {
            let updateStatus = await mdb.updatePasswordByEmail(decoded.email, password);
            if (updateStatus) {
                res.status(200).json({
                    message: '成功重置密碼',
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