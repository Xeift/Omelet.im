const express = require('express');
const path = require('path');
const router = express.Router();
const authController = require('../../controller/authController.js');


router.post('/submit-info', async(req, res) => {
    try {
        const { username, password } = req.body;
        let user = await authController.isPasswordMatch(username, password);
        if (user) {
            await authController.removeVerifiedUser(user.uid);
            res.status(200).json({
                message: '成功重置密碼',
                data: null,
                token: null
            });
        }
        else {
            res.status(401).json({
                message: '帳號或密碼錯誤',
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

router.get('/', async(req, res) => {
    res.sendFile(path.join(__dirname, '../../view/confirm-delete-my-account.html'));
});

module.exports = router;