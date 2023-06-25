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
const UserModel = mongoose.model('User', UserSchema);

app.use(express.static(__dirname + '/client')); // set express static file path
app.use(bodyParser.urlencoded({extended: false})); // set body-parser

app.get('/', (req, res) => { // set home router
    res.sendFile(__dirname + '/client/index.html');
});

app.post('/login', async (req, res) => { // set login router
    let username = req.body.username; // username in req
    let password = req.body.password; // password in req
    try {
        let user = await UserModel.findOne({username, password});
        if (user) { // user in collection
          res.send('登入成功，歡迎' + username);
        }
        else { // user not in collection
          res.send('登入失敗，帳號或密碼錯誤');
        }
    }
    catch (err) {
        res.send('發生錯誤：' + err.message);
    }
});


app.post('/register', async (req, res) => { // set register router
    let username = req.body.username;
    let password = req.body.password;
    try {
        let user = await UserModel.findOne({username});
        if (user) {
            res.send('註冊失敗，帳號已被使用');
        }
        else {
          await UserModel.create({username, password});
          res.send('註冊成功，歡迎' + username);
        }
    } catch (err) {
        res.send('發生錯誤：' + err.message);
    }
});

app.listen(3000, () => { // start server on port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});
