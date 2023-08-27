const mongoose = require('mongoose');
require('dotenv').config({ path: 'config/.env' });
const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }); // 連接至 Mongodb

const UserSchema = new mongoose.Schema({ // 建立 UserSchema
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: String,
    reset_temp_code: { type: String, unique: true },
});

const UserModel = mongoose.model('User', UserSchema); // 建立 UserModel