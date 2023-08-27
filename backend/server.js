const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');


const app = express();
app.use(cors()); // 啟用跨域資源共享
// app.use(cors({
//     'origin': 'http://localhost:3001/',
//     'methods': 'GET, HEAD, PUT, PATCH, POST, DELETE',
//     'preflightContinue': false,
// }));
app.use(express.static(__dirname + '/client')); // set express static folder path
app.use(bodyParser.json()); // deal with json requests


app.post('/api/v1/login', require('./api/login.js'));

app.post('*', require('./api/notfound.js'));

app.listen(3000, () => { // start server at port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});