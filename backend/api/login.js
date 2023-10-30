const authController = require('../controller/authController.js');
const jwt = require('../utils/jwt.js');
const express = require('express');
const router = express.Router();

router.post('/', async(req, res) => {
    let username = req.body.username; // username 可為 username 或 email
    let password = req.body.password;
    if (!username || !password) {
        res.status(422).json({
            message: '帳號密碼不可為空',
            data: null,
            token: null
        });
        return;
    }

    try {
        let user = await authController.isPasswordMatch(username, password);
        console.log(user);
        if (!user) {
            res.status(401).json({
                message: '帳號或密碼錯誤',
                data: null,
                token: null
            });
            return;
        }

        let token = await jwt.generateLoginJWT(
            user.uid,
            user.username,
            user.email
        );
        res.status(200).json({
            message: '登入成功',
            data: {
                uid: user.uid,
                username: user.username,
                email: user.email
            },
            token: token
        });
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