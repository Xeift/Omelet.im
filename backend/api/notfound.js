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