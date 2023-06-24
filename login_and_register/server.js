// app.js
const express = require('express');
const app = express();
const bodyParser = require('body-parser');

// 用一個變數來暫存帳號密碼，之後你可以改用資料庫
let users = {};

// 設定靜態資源路徑
app.use(express.static(__dirname + '/client'));

// 設定body-parser中介軟體
app.use(bodyParser.urlencoded({extended: false}));

// 設定首頁路由
app.get('/', (req, res) => {
    // 返回index.html
    res.sendFile(__dirname + '/client/index.html');
});

// 設定登入路由
app.post('/login', (req, res) => {
    // 獲取請求中的帳號密碼
    let username = req.body.username;
    let password = req.body.password;
    // 檢查帳號密碼是否正確
    if (users[username] && users[username] === password) {
        // 登入成功，返回一個訊息
        res.send('登入成功，歡迎' + username);
    } else {
        // 登入失敗，返回一個錯誤
        res.send('登入失敗，帳號或密碼錯誤');
    }
});

// 設定註冊路由
app.post('/register', (req, res) => {
    // 獲取請求中的帳號密碼
    let username = req.body.username;
    let password = req.body.password;
    // 檢查帳號是否已經存在
    if (users[username]) {
        // 帳號已存在，返回一個錯誤
        res.send('註冊失敗，帳號已被使用');
    } else {
        // 帳號不存在，將其存入變數中
        users[username] = password;
        // 註冊成功，返回一個訊息
        res.send('註冊成功，歡迎' + username);
    }
});

// 啟動伺服器，監聽3000端口
app.listen(3000, () => {
    console.log('伺服器已啟動，請訪問http://localhost:3000');
});
