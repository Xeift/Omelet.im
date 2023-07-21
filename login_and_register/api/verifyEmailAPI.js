const express = require('express');
const mdb = require('../config/mongodb.js');
const auth = require('../config/auth.js');


module.exports = async (req, res) => {
    let email = req.body.email; // username in req

    try {
        console.log(`${email} `);
        // let user = await mdb.isPasswordMatch(username, password); // verify password

        // if (user) { // username and password match
        //     let userid = await mdb.findIdByUsername(username); // get userid
        //     token = await auth.generateToken(userid, username); // generate jwt
        //     res.status(200).json({ // return token to client
        //         message: '登入成功',
        //         data: null,
        //         token: token
        //     });
        // }
        // else { // username and password not match
        //     let isUserExsists = await mdb.isUserExsists(username);
        //     res.status(401).json({
        //         message: '帳號或密碼錯誤',
        //         data: {isUserExsists: isUserExsists},
        //         token: null
        //     });
        // }
    }
    catch (err) { // error handle
        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
    }
};