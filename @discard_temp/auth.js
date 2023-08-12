const jwt = require('jsonwebtoken');

async function generateToken(_userid, _username) {
    const expiresIn = '1d';
    const secret = 'your-secret-key';
    const data = {
        id: _userid,
        username: _username
    };

    return jwt.sign(data, secret, { expiresIn });
}

async function generateRestorePasswordToken(_email) {
    const expiresIn = '10m';
    const secret = 'your-secret-key';
    const data = {
        email: _email
    };

    return jwt.sign(data, secret, { expiresIn });
}

function authenticateToken(req, res, next) { // jwt verify middleware
    const token = req.headers['authorization']; // get jwt in header
    if (!token) {
        console.log('no token');
        return res.status(401).json({ success: false, message: '未提供身份驗證令牌' });
    }

    jwt.verify(token, 'your-secret-key', (err, decoded) => { // verify jwt
        if (err) {
            console.log('token invalid');
            return res.status(401).json({ success: false, message: '身份驗證令牌無效' });
        }

        req.user = decoded; // user information
        next();
    });
}

module.exports = { generateToken, generateRestorePasswordToken, authenticateToken };