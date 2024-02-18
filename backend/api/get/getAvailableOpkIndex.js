const preKeyBundleController = require('../../controller/preKeyBundleController.js');
const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let ourUid = req.decodedToken._uid; // extract from JWT
        let theirUid = req.query.uid; // direct in api query
        let ipkPub = req.query.ipkPub;
        let deviceId = await preKeyBundleController.findDeviceIdByIpkPub(ourUid, ipkPub);
        console.log(`[getAvailableOpkIndex.js] deviceId: ${deviceId}`);

        let ourPreKeyIndex = await preKeyBundleController.getMultiDevicesAvailableOpkIndex(ourUid, true, deviceId);
        let theirPreKeyIndex = await preKeyBundleController.getMultiDevicesAvailableOpkIndex(theirUid, false, deviceId);
        
        res.status(200).json({
            message: '成功取得 Pre Key Index',
            data: { ourPreKeyIndex: ourPreKeyIndex, theirPreKeyIndex: theirPreKeyIndex },
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