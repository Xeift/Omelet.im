const jwt = require('jsonwebtoken');
require('dotenv').config({ path: 'config/.env' });
const JWT_SECRET = process.env.JWT_SECRET;
const util = require('util');
const jwtVerify = util.promisify(jwt.verify);

async function generateLoginJWT(_uid, _username, _email) {
    const encoded_token = jwt.sign(
        { _uid, _username, _email },
        JWT_SECRET,
        { expiresIn: '1d' }
    );
    return encoded_token;
}

async function generateRegisterJWT(_uid, _email) {
    const encoded_token = jwt.sign(
        { _uid, _email },
        JWT_SECRET,
        { expiresIn: '5m' }
    );
    return encoded_token;
}

async function generateRestorePasswordJWT(_email) {
    const encoded_token = jwt.sign(
        { email: _email },
        JWT_SECRET,
        { expiresIn: '5m' },
    );
    return encoded_token;
}

async function verifyJWT(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        res.status(401).json({
            message: '請提供 JWT',
            data: null,
            token: null
        });
    }
    else {
        jwt.verify(token, JWT_SECRET, async(err, payload) => {
            if (err) {
                res.status(403).json({
                    message: '此 JWT 已過期或失效',
                    data: null,
                    token: null
                });
            }
            else {
                req.decodedToken = payload;
                next();
            }
        });
    }
}

async function verifyJWTSocket(token) {
    console.log(token);
    if (!token) {
        return null;
    }
    else {
        try {
            const payload = await jwtVerify(token, JWT_SECRET);
            return payload;
        }
        catch (err) {
            return null;
        }
    }
}

module.exports = {
    generateLoginJWT,
    generateRegisterJWT,
    generateRestorePasswordJWT,
    verifyJWT,
    verifyJWTSocket
};