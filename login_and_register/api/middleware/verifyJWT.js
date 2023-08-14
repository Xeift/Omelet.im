const jwt = require('../../utils/jwt.js');


module.exports = async(req, res, next) => { // jwt verify middleware TODO: verify jwt middle ware
    const token = req.headers['authorization']; // get jwt in header
    // const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImExMTA1MTAzMjJAZ20udXNjLmVkdS50dyIsImlhdCI6MTY5MTY4MjgyMiwiZXhwIjoxNjkxNjgzNDIyfQ.z-piVruMC24roeP3d4DPqDBd3hOPgnUy4fpY0XQK1UQ';
    if (!token) {
        return res.status(401).json({ success: false, message: '未提供JWT' });
    }

    try {
        let re = await jwt.verifyJWT(token);
        req.user = re; // user information
        next();
    }
    catch (err) {
        return res.status(401).json({ success: false, message: err });
        // console.log('err');
        // console.log(err);
    }

    // jwt.verify(
    //     token,
    //     JWT_SECRET,
    //     (err, decoded) => { // verify jwt
    //         if (err) {
    //             return res.status(401).json({ success: false, message: 'JWT已失效' });
    //         }
    //         req.user = decoded; // user information
    //         next();
    //     }
    // );
};