const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const preKeyBundleController = require('../../controller/preKeyBundleController.js');

router.get('/', jwt.verifyJWT, async(req, res) => {
    try {
        let ourUid = req.decodedToken._uid; // extract from JWT
        let theirUid = req.query.uid; // direct in api query
        let multiDevicesOpkIndexesRandom = JSON.parse(req.query.multiDevicesOpkIndexesRandom);
        
        let ourOpkIds = multiDevicesOpkIndexesRandom['ourPreKeyIndexRandom'];
        let theirOpkIds = multiDevicesOpkIndexesRandom['theirPreKeyIndexRandom'];
        
        let ourPreKeyBundle = await preKeyBundleController.downloadMultiDevicesPreKeyBundle(ourUid, ourOpkIds);
        let theirPreKeyBundle = await preKeyBundleController.downloadMultiDevicesPreKeyBundle(theirUid, theirOpkIds);


        console.log(`[downloadPreKeyBundle.js] ourPreKeyBundle: ${JSON.stringify(ourPreKeyBundle)}`);
        console.log(`[downloadPreKeyBundle.js] theirPreKeyBundle: ${JSON.stringify(theirPreKeyBundle)}`);

        res.status(200).json({
            message: '成功下載 Pre Key Bundle',
            data: { 'ourPreKeyBundle': ourPreKeyBundle, 'theirPreKeyBundle': theirPreKeyBundle },
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