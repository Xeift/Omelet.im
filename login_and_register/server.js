const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mdb = require('./config/mongodb.js')
const auth = require('./config/auth.js')
const jwt = require('jsonwebtoken');


app.use(express.static(__dirname + '/client')); // set express static file path
app.use(bodyParser.urlencoded({extended: false})); // set body-parser



app.get('/', (req, res) => { // set home router
    res.sendFile(__dirname + '/client/index.html');
});

app.post('/login', async (req, res) => { // set login router
    let username = req.body.username; // username in req
    let password = req.body.password; // password in req
    try {
        // let user = await UserModel.findOne({username, password});
        let user = await mdb.login(username, password);

        if (user) { // user in collection
            // res.send('登入成功，歡迎' + username);
            let userid = await mdb.findIdByUsername(username);
            console.log(typeof(userid), userid)
            token = await auth.generateToken(userid, username); // TODO: id and username
            // 將token作為json物件傳回給客戶端
            res.json({ success: true, token: token });
        }
        else { // user not in collection
            res.json({ success: false, message: '登入失敗，帳號或密碼錯誤' });
        }
    }
    catch (err) {
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

// 受保護資源路由
app.get('/protected-resource', authenticateToken, (req, res) => {
    // 在這裡處理受保護資源的請求
    // 您可以在這裡使用 req.user 取得解碼後的使用者資訊
    // 根據需求進行授權處理
    const decodedToken = req.user;
    console.log(decodedToken);
    res.send({'decodedToken': decodedToken});
});
  
  // JWT 驗證中間件
  function authenticateToken(req, res, next) {
    // 獲取請求頭中的 JWT
    const token = req.headers['authorization'];
    console.log(token)
    if (!token) {
        console.log('no token')
      return res.status(401).json({ success: false, message: '未提供身份驗證令牌' });
    }
  
    // 驗證 JWT
    jwt.verify(token, 'your-secret-key', (err, decoded) => {
      if (err) {
        console.log('token invalid')
        return res.status(401).json({ success: false, message: '身份驗證令牌無效' });
      }
      // 驗證成功，將解碼後的使用者資訊存儲在請求物件中
      req.user = decoded;
      next();
    });
  }
  
  app.listen(3000, () => { // 在 3000 端口上啟動伺服器
    console.log('伺服器已啟動\nhttp://localhost:3000');
  });