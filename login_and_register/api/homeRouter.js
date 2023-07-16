const express = require('express');
const homeRouter = express.Router();


homeRouter.get('/', (req, res) => {
    res.sendFile(__dirname + '/client/index.html');
});


module.exports = homeRouter;