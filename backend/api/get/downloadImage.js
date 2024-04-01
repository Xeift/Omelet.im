const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const fs = require('fs');
const path = require('path');

router.get('/:id', async(req, res) => {
    try {
        const filePath = path.join(__dirname, '..', '..', 'img', req.params.id);
        console.log(filePath);
        res.sendFile(filePath, (err) => {
            if (err) {
                console.error(err);
                res.status(500).send(err);
            }
            else {
                fs.unlink(filePath, (err) => {
                    if (err) console.error(`Error removing file: ${err}`);
                });
            }
        });
    }
    catch (err) {
        console.log(err.message);
        console.log(err);

        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
    }
});

module.exports = router;