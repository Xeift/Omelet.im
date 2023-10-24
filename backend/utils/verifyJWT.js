const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET;

const verifyToken = async(req, res, next) => {
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
};

module.exports = { verifyToken };