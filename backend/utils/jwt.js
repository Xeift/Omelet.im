const jwt = require('jsonwebtoken');
require('dotenv').config({ path: 'config/.env' });
const JWT_SECRET = process.env.JWT_SECRET;

async function generateLoginJWT(_uid, _username, _email) {
    const token = jwt.sign(
        { _uid, _username, _email },
        JWT_SECRET,
        { expiresIn: '1d' }
    );
    return token;
}

async function generateRestorePasswordJWT(_email) {
    const token = jwt.sign(
        { email: _email },
        JWT_SECRET,
        { expiresIn: '5m' },
    );
    return token;
}

async function verifyJWT(token) {
    const decoded_token = jwt.verify(token, JWT_SECRET);
    return decoded_token;
}

module.exports = {
    generateLoginJWT,
    generateRestorePasswordJWT,
    verifyJWT
};