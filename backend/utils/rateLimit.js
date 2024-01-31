const rateLimit = require('express-rate-limit');
const authLimiter = rateLimit({
    windowMs: 5 * 60 * 1000,
    max: 20,
    handler: function(req, res) {
        res.status(429).json({
            message: 'API請求次數超過限制，請稍後再試',
            data: null,
            token: null
        });
    }
});

module.exports = { authLimiter };