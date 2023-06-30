const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mdb = require('./config/mongodb.js')
const auth = require('./config/auth.js')
// const jwt = require('jsonwebtoken');


app.use(express.static(__dirname + '/client')); // set express static file path
app.use(bodyParser.urlencoded({extended: false})); // set body-parser


app.get('/', (req, res) => { // set home router
    res.sendFile(__dirname + '/client/index.html');
});


app.post('/login', async (req, res) => { // set login router
    let username = req.body.username; // username in req
    let password = req.body.password; // password in req
    try {
        let user = await mdb.login(username, password); // verify password

        if (user) { // username and password match
            let userid = await mdb.findIdByUsername(username); // get userid
            token = await auth.generateToken(userid, username); // generate jwt
            res.json({ success: true, token: token }); // return token to client
        }
        else { // username and password not match
            res.json({ success: false, message: '登入失敗，帳號或密碼錯誤' });
        }
    }
    catch (err) { // error handle
        res.json({ success: false, message: '發生錯誤：' + err.message });
    }
});


app.post('/register', async (req, res) => { // set register router
    let username = req.body.username;
    let password = req.body.password;
    try {
        let user = await mdb.isUserExsists(username);
        if (user) {
            res.send('註冊失敗，帳號已被使用');
        }
        else {
            await mdb.register(username, password);
            res.send('註冊成功，歡迎' + username);
        }
    } catch (err) {
        res.send('發生錯誤：' + err.message);
    }
});


app.get('/protected-resource', auth.authenticateToken, (req, res) => { // protected resource (jwt required)
    const decodedToken = req.user; // decoded jwt
    res.send({'decodedToken': decodedToken});
});

  
app.listen(3000, () => { // start server at port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});