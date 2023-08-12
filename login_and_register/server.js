const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const jwt = require('./utils/jwt.js');


app.use(express.static(__dirname + '/client')); // set express static folder path
app.use(bodyParser.json()); // deal with json requests


app.get('/', require('./api/get/homePage.js'));
app.get('/forgot-password', require('./api/get/forgotPasswordPage.js'));
app.get('/msg', require('./api/get/msgPage.js'));
app.get('/protected-resource', jwt.verifyJWT, require('./api/get/protectedResourcePage.js'));
app.get('/update-password', require('./api/get/updatePasswordPage.js'));
app.get('/register', require('./api/get/registerPage.js'));


app.post('/api/auth/login', require('./api/post/loginAPI.js'));
app.post('/api/auth/reset-password', require('./api/post/resetPasswordAPI.js'));
app.post('/update-password', require('./api/post/updatePasswordAPI.js'));
app.post('/api/auth/verify-email', require('./api/post/verifyEmailAPI.js'));
app.post('/api/auth/register', require('./api/post/registerAPI.js'));


app.listen(3000, () => { // start server at port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});