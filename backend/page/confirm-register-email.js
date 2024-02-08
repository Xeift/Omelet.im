const express = require('express');
const path = require('path');
const router = express.Router();
const jwt = require('./../utils/jwt');
const authController = require('./../controller/authController');

router.get('/', async(req, res) => {
    try {
        let code = req.query.code;
        let decodedToken = await jwt.verifyJWTSocket(code);
        let uid = decodedToken['_uid'];
        let email = decodedToken['_email'];
        await authController.makeUnverifiedUserVerified(uid, email);

        res.sendFile(path.join(__dirname, 'confirm-register-email-success.html'));
    }
    catch (err) {
        res.sendFile(path.join(__dirname, 'confirm-register-email-failed.html'));
    }
});

module.exports = router;