const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config({ path: 'config/.env' });
const BACKEND_PORT = process.env.BACKEND_PORT;
const FRONTEND_URL = process.env.FRONTEND_URL;
const BACKEND_URL = process.env.BACKEND_URL;

const app = express();

app.use(cors({ // set cors
    origin: FRONTEND_URL,
    methods: 'GET, HEAD, PUT, PATCH, POST, DELETE',
    preflightContinue: false,
}));
app.use(express.static(__dirname + '/client')); // set express static folder path
app.use(bodyParser.json()); // deal with json requests

app.use('/api/v1/login', require('./api/login.js'));
app.use('/api/v1/register', require('./api/register.js'));
app.use('/api/v1/reset-password', require('./api/resetPassword.js'));

app.use('*', require('./api/notFound.js'));

app.listen(BACKEND_PORT, () => { // start server at port 3000
    console.log(`伺服器已啟動\n${BACKEND_URL}`);
});