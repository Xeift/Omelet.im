const nodemailer = require('nodemailer');
require('dotenv').config();
const GMAIL_APP_PASSWORD = process.env.GMAIL_APP_PASSWORD;
const auth = require('./../config/auth.js');

async function sendMail(email, code) {
    
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
        html: `<h1>Omelet 信箱驗證碼12345</h1><a href="http://localhost:3000/reset.html?code=${code}">按我重置密碼<a>`
    };
    
    transporter.sendMail(mailOptions);         
}

module.exports = { sendMail }