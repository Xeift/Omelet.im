const bcrypt = require('bcrypt');
const saltRounds = 10;

async function hashPassword(password) {
    const salt = await bcrypt.genSalt(saltRounds);
    const hash = await bcrypt.hash(password, salt);
    console.log('Hashed password:', hash);
    return hash;
}

async function checkPassword(password, hash) {
    const result = await bcrypt.compare(password, hash);
    console.log('Password matches hash:', result);
    return result;
}

module.exports = {
    hashPassword,
    checkPassword
};