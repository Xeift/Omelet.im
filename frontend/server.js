const express = require('express');
const app = express();
const bodyParser = require('body-parser');

app.use(express.static(__dirname + '/view')); // set express static folder path
app.use(bodyParser.json()); // deal with json requests

app.get('/', require('./route/homePage.js'));

app.listen(3001, () => { // start server at port 3001
    console.log('伺服器已啟動\nhttp://localhost:3001');
});