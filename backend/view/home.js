const express = require('express');
const path = require('path');
const router = express.Router();

router.get('/', async(req, res) => {
    res.sendFile(path.join(__dirname, 'home.html'));
});

module.exports = router;