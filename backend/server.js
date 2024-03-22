const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const rateLimit = require('./utils/rateLimit.js');
require('dotenv').config({ path: 'config/.env' });
const BACKEND_PORT = process.env.BACKEND_PORT;
const SERVER_URI = process.env.SERVER_URI;

const app = express();
const server = require('http').createServer(app);
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
app.use('/api/v1/get-unread-msg', rateLimit.authLimiter, require('./api/get/getUnreadMsg.js'));
app.use('/api/v1/check-jwt-status', rateLimit.authLimiter, require('./api/post/checkJwtStatus.js'));
app.use('/api/v1/upload-pre-key-bundle', rateLimit.authLimiter, require('./api/post/uploadPreKeyBundle.js'));
app.use('/api/v1/download-pre-key-bundle', rateLimit.authLimiter, require('./api/get/downloadPreKeyBundle.js'));
app.use('/api/v1/get-available-opk-index', rateLimit.authLimiter, require('./api/get/getAvailableOpkIndex.js'));
app.use('/api/v1/update-opk', rateLimit.authLimiter, require('./api/post/updateOpk.js'));
app.use('/api/v1/get-self-opk-status', rateLimit.authLimiter, require('./api/get/getSelfOpkStatus.js'));
app.use('/api/v1/get-self-spk-status', rateLimit.authLimiter, require('./api/get/getSelfSpkStatus.js'));
app.use('/api/v1/update-spk', rateLimit.authLimiter, require('./api/post/updateSpk.js'));
app.use('/api/v1/update-pfp', rateLimit.authLimiter, require('./api/post/updatePfp.js'));
app.use('/api/v1/upload-img', rateLimit.authLimiter, require('./api/post/uploadImg.js'));
app.use('/api/v1/get-user-public-info', rateLimit.authLimiter, require('./api/get/getUserPublicInfo.js'));
app.use('/api/v1/send-friend-request', rateLimit.authLimiter, require('./api/post/sendFriendRequest.js'));
app.use('/api/v1/reply-friend-request', rateLimit.authLimiter, require('./api/post/replyFriendRequest.js'));
app.use('/api/v1/get-friend-list', rateLimit.authLimiter, require('./api/get/getFriendList.js'));
app.use('/api/v1/get-friend-request', rateLimit.authLimiter, require('./api/get/getFriendRequest.js'));


app.use('/confirm-register-email', rateLimit.authLimiter, require('./page/confirm-register-email.js'));
app.use('/confirm-reset-email', rateLimit.authLimiter, require('./page/confirm-reset-email.js'));

app.use('/pfp', express.static('pfp'));

app.use('*', require('./api/notFound.js'));

// TODO: debug 用，重置 PreKeyBundle
// const preKeyBundleController = require('./controller/preKeyBundleController.js');
// preKeyBundleController.debugResetPreKeyBundle();

server.listen(BACKEND_PORT, () => {
    console.log(`後端伺服器已啟動\n${SERVER_URI}`);
});