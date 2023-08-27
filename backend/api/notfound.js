const mdb = require('../utils/mongodb.js');
const jwt = require('../utils/jwt.js');


module.exports = async(req, res) => {
    res.status(404).json({
        message: 'Not Found',
        data: null,
        token: null
    });
};