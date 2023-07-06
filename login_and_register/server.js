const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mdb = require('./config/mongodb.js')
const auth = require('./config/auth.js')
const email = require('./utils/email.js')

app.use(express.static(__dirname + '/client')); // set express static file path
// app.use(bodyParser.urlencoded({extended: false})); // set body-parser
app.use(bodyParser.json());


app.get('/', (req, res) => { // set home router
    res.sendFile(__dirname + '/client/index.html');
});



app.post('/api/auth/login', async (req, res) => { // set login router /api/auth
    let username = req.body.username; // username in req
    let password = req.body.password; // password in req

    try {
        let user = await mdb.isPasswordMatch(username, password); // verify password

        if (user) { // username and password match
            console.log('[user exsist] [password match]'); 
            let userid = await mdb.findIdByUsername(username); // get userid
            token = await auth.generateToken(userid, username); // generate jwt
            res.json({ success: true, token: token }); // return token to client
        }
        else { // username and password not match
            let usernameType = await mdb.isUserExsists(username);
            res.json({ success: false, usernameType: usernameType });
        }
    }
    catch (err) { // error handle
        res.json({ success: false, message: '發生錯誤：' + err.message });
    }
}); 

app.post('/api/auth/register', async (req, res) => { // set register router
    let username = req.body.username;
    let email = '';
    let password = req.body.password;
    
    try {
        let user = await mdb.isUserExsists(username);
        if (user) {
            res.send('註冊失敗，帳號已被使用');
        }
        else {
            await mdb.register(username, email, password);
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