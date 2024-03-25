const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const friendController = require('../../controller/friendController.js');
const authController = require('../../controller/authController.js');
const eventEmitter = require('../../utils/eventEmitter.js');


router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;
    let theirIdentifier = req.body.theirIdentifier;
    let theirUid;
    let type = req.body.type;

    if (type === 'uid') {
        theirUid = theirIdentifier;
    }
    else if (type === 'username') {
        theirUid = await authController.getUidByUsername(theirIdentifier);
    }
    else if (type === 'email') {
        theirUid = await authController.getUidByEmail(theirIdentifier);
    }


    let isTheirUidExsists = await authController.isUserIdExsists(theirUid);
    let isFriend = await friendController.isFriend(theirUid, ourUid);
    let friendRequestExists = await friendController.isFriendRequestExists(ourUid, theirUid);

    try {
        if (!isTheirUidExsists) {
            res.status(403).json({
                message: '傳送好友邀請者不存在',
                data: null,
                token: null
            });  
            return;
        }

        if (isFriend) {
            res.status(409).json({
                message: '已為好友，無需傳送好友邀請',
                data: null,
                token: null
            });  
            return;
        }

        if (friendRequestExists) {
            res.status(409).json({
                message: '已傳送過好友邀請，請等待對方回覆',
                data: null,
                token: null
            });
            return;
        }

        await friendController.sendFriendRequest(ourUid, theirUid);
        eventEmitter.emit('receivedFriendRequest', {
            'initiatorUid': ourUid,
            'targetUid': theirUid,
            'timestamp': Date.now()
        });
        
        res.status(200).json({
            message: '好友邀請傳送成功',
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