const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const rateLimit = require('./utils/rateLimit.js');
require('./config/config.js');
const AWS_BACKEND_PORT = process.env.AWS_BACKEND_PORT;
const AWS_LOCAL_SERVER_URI = process.env.AWS_LOCAL_SERVER_URI; // 8443
const fs = require('fs');

const privateKey = fs.readFileSync('config/cf.key', 'utf8');
const certificate = fs.readFileSync('config/cf.crt', 'utf8');
const credentials = { key: privateKey, cert: certificate };
console.log(`[server] credentials: ${JSON.stringify(credentials)}`);

const app = express();
const server = require('https').createServer(credentials, app);
const io = require('socket.io')(server, {
    cors: {}
});

const socket = require('./utils/socket.js')(io);

app.use(cors({}));
app.use(express.static(__dirname + '/client'));
app.use(bodyParser.json());

app.use('/api/v1/login', rateLimit.authLimiter, require('./api/post/login.js'));
app.use('/api/v1/register', rateLimit.authLimiter, require('./api/post/register.js'));
app.use('/api/v1/reset-password', rateLimit.authLimiter, require('./api/post/resetPassword.js'));
app.use('/api/v1/delete-my-account', rateLimit.authLimiter, require('./api/post/deleteMyAccount.js'));
app.use('/api/v1/get-unread-msg', rateLimit.authLimiter, require('./api/get/getUnreadMsg.js'));
app.use('/api/v1/upload-pre-key-bundle', rateLimit.authLimiter, require('./api/post/uploadPreKeyBundle.js'));
app.use('/api/v1/download-pre-key-bundle', rateLimit.authLimiter, require('./api/get/downloadPreKeyBundle.js'));
app.use('/api/v1/get-available-opk-index', rateLimit.authLimiter, require('./api/get/getAvailableOpkIndex.js'));
app.use('/api/v1/get-self-opk-status', rateLimit.authLimiter, require('./api/get/getSelfOpkStatus.js'));
app.use('/api/v1/get-self-spk-status', rateLimit.authLimiter, require('./api/get/getSelfSpkStatus.js'));
app.use('/api/v1/update-opk', rateLimit.authLimiter, require('./api/post/updateOpk.js'));
app.use('/api/v1/update-spk', rateLimit.authLimiter, require('./api/post/updateSpk.js'));
app.use('/api/v1/update-pfp', rateLimit.authLimiter, require('./api/post/updatePfp.js'));
app.use('/api/v1/upload-img', rateLimit.authLimiter, require('./api/post/uploadImg.js'));
app.use('/api/v1/get-user-public-info', rateLimit.authLimiter, require('./api/get/getUserPublicInfo.js'));
app.use('/api/v1/send-friend-request', rateLimit.authLimiter, require('./api/post/sendFriendRequest.js'));
app.use('/api/v1/cancel-friend-request', rateLimit.authLimiter, require('./api/post/cancelFriendRequest.js'));
app.use('/api/v1/reply-friend-request', rateLimit.authLimiter, require('./api/post/replyFriendRequest.js'));
app.use('/api/v1/get-friend-request', rateLimit.authLimiter, require('./api/get/getFriendRequest.js'));
app.use('/api/v1/get-friend-list', rateLimit.authLimiter, require('./api/get/getFriendList.js'));
app.use('/api/v1/get-device-ids', rateLimit.authLimiter, require('./api/get/getDeviceIds.js'));
app.use('/api/v1/remove-friend', rateLimit.authLimiter, require('./api/post/removeFriend.js'));
app.use('/api/v1/get-translated-sentence', rateLimit.authLimiter, require('./api/post/getTranslatedSentence.js'));

app.use('/pfp', express.static('pfp'));
app.use('/img', rateLimit.authLimiter, require('./api/get/downloadImage.js'));


app.use('*', require('./api/notFound.js'));


server.listen(AWS_BACKEND_PORT, () => {
    console.log(`後端伺服器已啟動\n${AWS_LOCAL_SERVER_URI}`);
});