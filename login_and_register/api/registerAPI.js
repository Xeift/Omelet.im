const express = require('express');
const mdb = require('../config/mongodb.js');
const auth = require('../config/auth.js');


module.exports = async (req, res) => {
    let username = req.body.username;
    let email = '';
    let password = req.body.password;

    try {
        console.log('test');
    }
    catch (err) { // error handle
        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
    }
};