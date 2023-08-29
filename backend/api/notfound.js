const mdb = require('../utils/mongodb.js');
const jwt = require('../utils/jwt.js');
const express = require('express');
const router = express.Router();

router.post('/', async(req, res) => {
    res.status(404).json({
        message: 'Not Found',
        data: null,
        token: null
    });
});

module.exports = router;