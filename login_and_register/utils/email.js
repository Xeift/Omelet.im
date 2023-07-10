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
        subject: 'Omelet - 重置密碼申請',
        html: `<h1>Omelet - 重置密碼申請</h1><p>我們收到您重置密碼的申請。<br>若您並未請求重置密碼，請忽略此郵件。<br>若您要重設密碼，請點擊下方藍字並按照網頁中的指示操作。</p><a href="http://localhost:3000/reset.html?code=${code}">按我重置密碼<a>`
    };
    
    transporter.sendMail(mailOptions);         
}

module.exports = { sendMail }