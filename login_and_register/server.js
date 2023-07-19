const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mdb = require('./config/mongodb.js');
const auth = require('./config/auth.js');
const email = require('./utils/email.js');
const jwt = require('jsonwebtoken');


app.use(express.static(__dirname + '/client')); // set express static file path
app.use(bodyParser.json());


app.get('/', require('./api/homeAPI.js'));
app.post('/api/auth/login', require('./api/loginAPI.js'));
app.get('/forgot-password', require('./api/forgotPasswordAPI.js'))
app.post('/api/auth/reset-password', require('./api/resetPasswordAPI.js'));
app.get('/msg', require('./api/msgAPI.js'));
app.get('/protected-resource', auth.authenticateToken, require('./api/protectedResourceAPI.js'));
app.get('/update-password', require('./api/updatePasswordPage.js'));
app.post('/update-password', require('./api/updatePasswordAPI.js'));



// app.post('/api/auth/register', async (req, res) => { // set register router
//     let username = req.body.username;
//     let email = '';
//     let password = req.body.password;
    
//     try {
//         let user = await mdb.isUserExsists(username);
//         if (user) {
//             res.send('註冊失敗，帳號已被使用');
//         }
//         else {
//             await mdb.register(username, email, password);
//             res.send('註冊成功，歡迎' + username);
//         }
//     }
//     catch (err) {
//         res.send('發生錯誤：' + err.message);
//     }
// });


app.listen(3000, () => { // start server at port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});