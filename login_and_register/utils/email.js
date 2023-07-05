const nodemailer = require('nodemailer');
require('dotenv').config();
const GMAIL_APP_PASSWORD = process.env.GMAIL_APP_PASSWORD;

async function sendMail(email) {
    
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'elpma.res@gmail.com',
            pass: GMAIL_APP_PASSWORD
        }
    });
    
    const mailOptions = {
        from: 'elpma.res@gmail.com',
        to: email,
        subject: 'Omelet 信箱驗證碼',
        html: `<h1>Omelet 信箱驗證碼12345</h1>`
    };
    
    transporter.sendMail(mailOptions);         
}

module.exports = { sendMail }