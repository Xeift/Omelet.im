const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mdb = require('./config/mongodb.js');
const auth = require('./config/auth.js');
const email = require('./utils/email.js');
const jwt = require('jsonwebtoken');


app.use(express.static(__dirname + '/client')); // set express static file path
app.use(bodyParser.json());


app.get('/', require('./api/homeAPI.js'));
app.post('/api/auth/login', require('./api/loginAPI.js'));







app.post('/api/auth/register', async (req, res) => { // set register router
    let username = req.body.username;
    let email = '';
    let password = req.body.password;
    
    try {
        let user = await mdb.isUserExsists(username);
        if (user) {
            res.send('註冊失敗，帳號已被使用');
        }
        else {
            await mdb.register(username, email, password);
            res.send('註冊成功，歡迎' + username);
        }
    }
    catch (err) {
        res.send('發生錯誤：' + err.message);
    }
});


app.post('/api/auth/restore', async (req, res) => { // set restore router
    let emailData = req.body.email;
    
    try {
        let isEmailExsists = await mdb.isEmailExsists(emailData);
        if (isEmailExsists) { 
            const code = await auth.generateRestorePasswordToken(emailData);
            await mdb.saveResetTempCode(emailData, code);
            await email.sendMail(emailData, code);
            res.json({ success: true });
        }
        else {
            res.json({ success: false });
        }
    }
    catch (err) {
        console.log(err);
        res.json({ success: false});
    }
});


app.get('/protected-resource', auth.authenticateToken, (req, res) => { // protected resource (jwt required)
    const decodedToken = req.user; // decoded jwt
    res.send({'decodedToken': decodedToken});
});


app.post('/reset', async (req, res) => {
    try {
        // Get the code and password from the request body
        const { code, password } = req.body;
        // Verify the code as a jwt token with the secret key
        const decoded = jwt.verify(code, 'your-secret-key');
        console.log(decoded);
        console.log(decoded.id);
        // Get the user id from the decoded payload
        // const userId = decoded.id;
        // // Find the user by id in the database (use your own logic here)
        // const user = await User.findById(userId);
        // // Check if the user exists
        // if (!user) {
        //     // Send an error response
        //     res.status(404).json({ message: 'User not found' });
        //     return;
        // }
        // // Update the user's password (use your own logic here)
        // await user.updatePassword(password);
        // // Send a success response
        res.status(200).json({ message: 'Password reset successfully' });
    }
    catch (error) {
        // Send an error response
        res.status(500).json({ message: error.message });
    }
});

  
app.listen(3000, () => { // start server at port 3000
    console.log('伺服器已啟動\nhttp://localhost:3000');
});