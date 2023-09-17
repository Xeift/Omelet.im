const UserModel = require('./../model/userModel');

async function isPasswordMatch(username, password) {
    try {
        let user = await UserModel.findOne({ username: username, password: password }) || await UserModel.findOne({ email: username, password: password });
        console.log('dasdasdasdasda');
        if (user) {
            return user;
        }
        else {
            return false;
        }
    }
    catch (err) {
        console.log(`mongodb.js: ${err}`);
    }
}

module.exports = {
    isPasswordMatch
};