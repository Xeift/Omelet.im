const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const friendController = require('../../controller/friendController.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    let theirUid = req.body.theirUid;

    let friendRequestStatus = await friendController.sendFriendRequest(ourUid, theirUid);
    let isFriend = await friendController.isFriend(theirUid, ourUid);

    try {
        if (isFriend) {
            res.status(409).json({
                message: '已為好友，無需傳送好友邀請',
                data: null,
                token: null
            });  
            return;
        }

        if (friendRequestStatus === 'duplicate_friend_req') {
            res.status(409).json({
                message: '已傳送過好友邀請，請等待對方回覆',
                data: null,
                token: null
            });  
        }
        else if (friendRequestStatus === 'success') {
            res.status(200).json({
                message: '好友邀請傳送成功',
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

module.exports = router;