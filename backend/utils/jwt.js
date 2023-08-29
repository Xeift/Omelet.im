const jwt = require('jsonwebtoken');
require('dotenv').config({ path: 'config/.env' });
const JWT_SECRET = process.env.JWT_SECRET;

async function generateLoginJWT(_userid, _username) {
    return new Promise((resolve, reject) => {
        jwt.sign(
            { id: _userid, username: _username },
            JWT_SECRET,
            { expiresIn: '1d' },
            (err, token) => {
                if (err) {
                    reject(false);
                }
                else {
                    resolve(token);
                }
            }
        );
    });
}

async function generateRestorePasswordJWT(_email) {
    return new Promise((resolve, reject) => {
        jwt.sign(
            { email: _email },
            JWT_SECRET,
            { expiresIn: '5m' },
            (err, token) => {
                if (err) {
                    reject(false);
                }
                else {
                    resolve(token);
                }
            }
        );
    });
}

module.exports = { generateLoginJWT, generateRestorePasswordJWT };