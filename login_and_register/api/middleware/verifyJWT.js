const jwt = require('../../utils/jwt.js');

module.exports = async(req, res, next) => {
    const token = req.headers['authorization']; // get jwt in header
    if (!token) {
        return res.status(401).json({ success: false, message: '未提供JWT' });
    }

    try {
        let userInfo = await jwt.verifyJWT(token);
        req.user = userInfo;
        next();
    }
    catch (err) {
        return res.status(401).json({ success: false, message: err });
    }
};