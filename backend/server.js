const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const rateLimit = require('./utils/rateLimit.js');
require('dotenv').config({ path: 'config/.env' });
const BACKEND_PORT = process.env.BACKEND_PORT;
const FRONTEND_URL = process.env.FRONTEND_URL;
const BACKEND_URL = process.env.BACKEND_URL;

const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server, {
    cors: {
        // origin: 'http://localhost:3001'
    }
});

const socket = require('./utils/socket.js')(io); // handle socket events

app.use(cors({
    // origin: FRONTEND_URL,
    // methods: 'GET, HEAD, PUT, PATCH, POST, DELETE',
    // preflightContinue: false,
}));
app.use(express.static(__dirname + '/client'));
app.use(bodyParser.json());

app.use('/api/v1/login', rateLimit.authLimiter, require('./api/login.js'));
app.use('/api/v1/register', rateLimit.authLimiter, require('./api/register.js'));
app.use('/api/v1/reset-password', rateLimit.authLimiter, require('./api/resetPassword.js'));
app.use('/api/v1/message', rateLimit.authLimiter, require('./api/message.js'));
app.use('/api/v1/get-unread-msg', rateLimit.authLimiter, require('./api/getUnreadMsg.js'));
app.use('/api/v1/check-jwt-status', rateLimit.authLimiter, require('./api/checkJwtStatus.js'));
app.use('/api/v1/upload-pre-key-bundle', rateLimit.authLimiter, require('./api/uploadPreKeyBundle.js'));
app.use('/api/v1/download-pre-key-bundle', rateLimit.authLimiter, require('./api/downloadPreKeyBundle.js'));
app.use('/api/v1/get-available-opk-index', rateLimit.authLimiter, require('./api/getAvailableOpkIndex.js'));


function testMsg() {
    const msgController = require('./controller/msgController.js');
    msgController.storeUnreadMsg(1698143242, 'text', '491437500754038784', '504619688634880000', '原神啟動')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143243, 'text', '491437500754038784', '492312533160431617', '我最喜歡玩原神了')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143244, 'text', '491437500754038784', '504619688634880000', '可莉')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143246, 'text', '491437500754038784', '504620939263086593', '蹦蹦炸彈')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143247, 'text', '491437500754038784', '504622124325933058', '這是我新買的衣服')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143248, 'text', 'aaaaaaaaaaaa', '504623456789012345', '你喜歡什麼遊戲？')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143249, 'text', '491437500754038784', '504624567890123456', '我最近在玩動物之森')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143250, 'text', '491437500754038784', '504625678901234567', '動物之森很好玩嗎？')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143251, 'text', '491437500754038784', '504626789012345678', '還不錯啦，就是有點無聊')
        .catch(err => console.log(err));
    msgController.storeUnreadMsg(1698143252, 'text', 'aaaaaaaaaaaa', '504627890123456789', '那你可以試試看原神，我覺得很有趣')
        .catch(err => console.log(err));
}
// testMsg();



app.use('*', require('./api/notFound.js'));

server.listen(BACKEND_PORT, () => {
    console.log(`後端伺服器已啟動\n${BACKEND_URL}`);
});