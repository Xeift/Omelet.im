const mongoose = require('mongoose');
require('dotenv').config();
const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(MONGO_URI, {useNewUrlParser: true, useUnifiedTopology: true}); // connect to mongodb
const UserSchema = new mongoose.Schema({ // define user schema
    username: {type: String, unique: true}, // username
    password: String // password
});
const UserModel = mongoose.model('User', UserSchema);

async function login(username, password) {
    try {
        let user = await UserModel.findOne({username, password});
        if (user) { // user in collection
            return true;
        }
        else { // user not in collection
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

async function isUserExsists(username) {
    try {
        let user = await UserModel.findOne({username});
        if (user) { // user in collection
            return true;
        }
        else { // user not in collection
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

async function register(username, password) {
    try {
        UserModel.create({username, password});
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

module.exports = { login, isUserExsists, register }