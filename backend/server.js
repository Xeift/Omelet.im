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
        origin: 'http://localhost:3001'
    }
});

const socket = require('./utils/socket.js')(io); // handle socket events

app.use(cors({
    origin: FRONTEND_URL,
    methods: 'GET, HEAD, PUT, PATCH, POST, DELETE',
    preflightContinue: false,
}));
app.use(express.static(__dirname + '/client'));
app.use(bodyParser.json());

app.use('/api/v1/login', rateLimit.authLimiter, require('./api/login.js'));
app.use('/api/v1/register', rateLimit.authLimiter, require('./api/register.js'));
app.use('/api/v1/reset-password', rateLimit.authLimiter, require('./api/resetPassword.js'));
app.use('/api/v1/message', rateLimit.authLimiter, require('./api/message.js'));

app.use('*', require('./api/notFound.js'));

server.listen(BACKEND_PORT, () => {
    console.log(`後端伺服器已啟動\n${BACKEND_URL}`);
});