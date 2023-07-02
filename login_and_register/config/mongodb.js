const mongoose = require('mongoose');
require('dotenv').config();
const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(MONGO_URI, {useNewUrlParser: true, useUnifiedTopology: true}); // connect to mongodb
const UserSchema = new mongoose.Schema({
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: String
});

const UserModel = mongoose.model('User', UserSchema);

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

async function verify(username, password) {
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

async function register(username, email, password ) {
    try {
        UserModel.create({ username, email, password });
    } catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}


async function findIdByUsername(_username) {
    try {
        const user = await UserModel.findOne({ username: _username });
        if (user) {
            return user.id;
        }
        else {
            return false;
        }
    }
    catch (error) {
        console.error(error);
    }
};

module.exports = { isUserExsists, verify, login, register, findIdByUsername }