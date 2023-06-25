const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
require('dotenv').config();
const uri = process.env.MONGO_URI;


mongoose.connect(uri, {useNewUrlParser: true, useUnifiedTopology: true}); // connect to mongodb

const UserSchema = new mongoose.Schema({ // define user schema
    username: {type: String, unique: true}, // username
    password: String // password
});

// 用UserSchema創建一個UserModel
const UserModel = mongoose.model('User', UserSchema);

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
app.post('/login', async (req, res) => {
    // 獲取請求中的帳號密碼
    let username = req.body.username;
    let password = req.body.password;
    // 檢查帳號密碼是否正確
    try {
      // 用UserModel查詢資料庫中是否有匹配的使用者
      let user = await UserModel.findOne({username, password});
      if (user) {
        // 登入成功，返回一個訊息
        res.send('登入成功，歡迎' + username);
      } else {
        // 登入失敗，返回一個錯誤
        res.send('登入失敗，帳號或密碼錯誤');
      }
    } catch (err) {
      // 發生錯誤，返回一個錯誤
      res.send('發生錯誤：' + err.message);
    }
});

// 設定註冊路由
app.post('/register', async (req, res) => {
    // 獲取請求中的帳號密碼
    let username = req.body.username;
    let password = req.body.password;
    // 檢查帳號是否已經存在
    try {
      // 用UserModel查詢資料庫中是否有匹配的使用者
      let user = await UserModel.findOne({username});
      if (user) {
        // 帳號已存在，返回一個錯誤
        res.send('註冊失敗，帳號已被使用');
      } else {
        // 帳號不存在，用UserModel新增一個使用者到資料庫中
        await UserModel.create({username, password});
        // 註冊成功，返回一個訊息
        res.send('註冊成功，歡迎' + username);
      }
    } catch (err) {
      // 發生錯誤，返回一個錯誤
      res.send('發生錯誤：' + err.message);
    }
});

// 啟動伺服器，監聽3000端口
app.listen(3000, () => {
    console.log('伺服器已啟動，請訪問http://localhost:3000');
});
