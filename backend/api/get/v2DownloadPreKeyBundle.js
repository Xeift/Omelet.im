const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const friendController = require('../../controller/friendController.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let ourUid = req.decodedToken._uid; // extract from JWT
        let theirUid = req.query.theirUid; // direct in api query
        let theirDeviceId = req.query.theirDeviceId; // direct in api query
        let opkId = JSON.parse(req.query.opkId);
        
        

        if (!await friendController.isFriend(ourUid, theirUid)) {
            if (ourUid !== theirUid) {
                res.status(401).json({
                    message: '新增好友後方可下載 Pre Key Bundle',
                    data: null,
                    token: null
                });
            }
        }
        
        let preKeyBundle = await preKeyBundleController.downloadPreKeyBundle(theirUid, theirDeviceId, opkId);
        await preKeyBundleController.v2DeleteOpkPub(theirUid, theirDeviceId, opkId);

        console.log(`已刪除 ${theirUid} ${theirDeviceId} 的 opk id: ${opkId}`);

        res.status(200).json({
            message: '成功下載 Pre Key Bundle',
            data: { 'PreKeyBundle': preKeyBundle },
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