const mongoose = require('mongoose');
require('dotenv').config();
const MONGO_URI = process.env.MONGO_URI;
const utils = require('.././utils/user_utils.js')

mongoose.connect(MONGO_URI, {useNewUrlParser: true, useUnifiedTopology: true}); // connect to mongodb
const UserSchema = new mongoose.Schema({
    username: { type: String, unique: true },
    email: { type: String, unique: true },
    password: String,
    reset_temp_code: { type: String, unique: true },
});

const UserModel = mongoose.model('User', UserSchema);

async function isUserExsists(input) {
    try {
        if (await UserModel.findOne({username: input}) || await UserModel.findOne({email: input})) { // username or email exsists
            return true;
        }
        else { // username or email not exsists
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

async function isEmailExsists(input) {
    try {
        if (await UserModel.findOne({email: input})) { // email exsists
            return true;
        }
        else { // email not exsists
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

async function isPasswordMatch(username, password) {
    try {
        let user = await UserModel.findOne({ username: username, password: password }) || await UserModel.findOne({ email: username, password: password });

        if (user) { // username or email match password
            return true;
        }
        else { // username or email not match password
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
    }
    catch (err) {
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

async function saveResetTempCode(email, newResetTempCode) {
    try {
        const updatedUser = await UserModel.findOneAndUpdate({ email: email }, { reset_temp_code: newResetTempCode }, { new: true });
        if (updatedUser) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (err) {
        return `後端發生例外錯誤： ${err.message}`;
    }
}



module.exports = { isUserExsists, isEmailExsists, isPasswordMatch, register, findIdByUsername, saveResetTempCode }