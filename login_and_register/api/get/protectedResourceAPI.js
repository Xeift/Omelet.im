const path = require('path');


module.exports = (req, res) => {
    const decodedToken = req.user; // decoded jwt
    res.send({'decodedToken': decodedToken}); // TODO:
};