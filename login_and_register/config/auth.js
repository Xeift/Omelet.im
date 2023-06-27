const jwt = require('jsonwebtoken');

async function generateToken(_userid, _username) {
    const expiresIn = '1h';
    const secret = 'your-secret-key';
    const data = {
        id: _userid,
        username: _username
    };

    return jwt.sign(data, secret, { expiresIn });
}



module.exports = { generateToken }