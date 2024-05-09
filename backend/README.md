
```
backend
├─ .DS_Store
├─ .eslintrc.json
├─ api
│  ├─ debug.js
│  ├─ get
│  │  ├─ downloadImage.js
│  │  ├─ downloadPreKeyBundle.js
│  │  ├─ getAvailableOpkIndex.js
│  │  ├─ getDeviceIds.js
│  │  ├─ getFriendList.js
│  │  ├─ getFriendRequest.js
│  │  ├─ getSelfOpkStatus.js
│  │  ├─ getSelfSpkStatus.js
│  │  ├─ getUnreadMsg.js
│  │  └─ getUserPublicInfo.js
│  ├─ notFound.js
│  └─ post
│     ├─ cancelFriendRequest.js
│     ├─ getTranslatedSentence.js
│     ├─ login.js
│     ├─ register.js
│     ├─ removeFriend.js
│     ├─ replyFriendRequest.js
│     ├─ resetPassword.js
│     ├─ sendFriendRequest.js
│     ├─ updateOpk.js
│     ├─ updatePfp.js
│     ├─ updateSpk.js
│     ├─ uploadImg.js
│     └─ uploadPreKeyBundle.js
├─ aws_server.js
├─ config
│  ├─ .env
│  ├─ .env.example
│  ├─ cf.crt
│  └─ cf.key
├─ controller
│  ├─ authController.js
│  ├─ friendController.js
│  ├─ msgController.js
│  └─ preKeyBundleController.js
├─ img
├─ model
│  ├─ friendRequestModel.js
│  ├─ mongoose.js
│  ├─ msgModel.js
│  ├─ preKeyBundleModel.js
│  ├─ unverifiedUserModel.js
│  └─ verifiedUserModel.js
├─ package-lock.json
├─ package.json
├─ page
│  ├─ confirm-register-email-failed.html
│  ├─ confirm-register-email-success.html
│  ├─ confirm-reset-email.html
│  └─ confirm-reset-email.js
├─ pfp
│  ├─ 552415467919118336.png
│  └─ 561550071007547392.png
├─ server.js
└─ utils
   ├─ email.js
   ├─ eventEmitter.js
   ├─ jwt.js
   ├─ passwordHelper.js
   ├─ rateLimit.js
   ├─ snowflakeId.js
   └─ socket.js

```