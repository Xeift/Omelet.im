const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const friendController = require('../../controller/friendController.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let decodedToken = req.decodedToken;
        let uid = decodedToken._uid;

        let friendRequest = await friendController.getFriendRequest(uid);

        res.status(200).json({
            message: '成功取得好友邀請',
            data: friendRequest,
            token: null
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