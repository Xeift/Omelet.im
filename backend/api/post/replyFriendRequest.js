const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const friendController = require('../../controller/friendController.js');
const eventEmitter = require('../../utils/eventEmitter.js');

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    let theirUid = req.body.theirUid;
    let isAgree = req.body.isAgree;
    let isFriend = await friendController.isFriend(theirUid, ourUid);
    let friendRequestExists = await friendController.isFriendRequestExists(theirUid, ourUid);

    try {
        if (isFriend) {
            res.status(409).json({
                message: '已為好友，無需回覆好友邀請',
                data: null,
                token: null
            });  
            return;
        }
        
        if (!friendRequestExists) {
            res.status(400).json({
                message: '並未收到來自該使用者的好友邀請',
                data: null,
                token: null
            });
            return;
        }

        if (isAgree) {
            await friendController.addFriend(ourUid, theirUid);
            await friendController.removeFriendRequest(theirUid, ourUid);

            eventEmitter.emit('acceptedFriendRequestJs', {
                'timestamp': Date.now(),
                'type': 'system_notify',
                'initiatorUid': theirUid,
                'targetUid': ourUid
            });

            res.status(200).json({
                message: '已同意對方的好友邀請',
                data: null,
                token: null
            });
        }
        else {
            await friendController.removeFriendRequest(ourUid, theirUid);

            res.status(200).json({
                message: '已拒絕對方的好友邀請',
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