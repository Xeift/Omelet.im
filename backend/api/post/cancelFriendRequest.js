const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const friendController = require('../../controller/friendController.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    let theirUid = req.body.theirUid;


    let friendRequestExists = await friendController.isFriendRequestExists(ourUid, theirUid);

    try {
        if (!friendRequestExists) {
            res.status(409).json({
                message: '您並未傳送該好友邀請',
                data: null,
                token: null
            });
            return;
        }

        await friendController.removeFriendRequest(ourUid, theirUid);
        res.status(200).json({
            message: '成功移除好友邀請',
            data: null,
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