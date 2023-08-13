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

async function verifyJWT(req, res, next) { // jwt verify middleware
    const token = req.headers['authorization']; // get jwt in header
    if (!token) {
        return res.status(401).json({ success: false, message: '未提供JWT' });
    }
    jwt.verify(
        token,
        JWT_SECRET,
        (err, decoded) => { // verify jwt
            if (err) {
                return res.status(401).json({ success: false, message: 'JWT已失效' });
            }
            req.user = decoded; // user information
            next();
        }
    );
}

module.exports = { generateLoginJWT, generateRestorePasswordJWT, verifyJWT };