const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');



const app = express();
app.use(cors());
// app.use(cors({ origin: 'http://localhost:3001/' }));

app.use(express.static(__dirname + '/client')); // set express static folder path
app.use(bodyParser.json()); // deal with json requests



app.post('/api/auth/register', require('./api/post/registerAPI.js'));
app.post('/api/auth/verify-email', require('./api/post/verifyEmailAPI.js'));


app.listen(3000, () => { // start server at port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});