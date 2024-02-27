const nodemailer = require('nodemailer');
require('dotenv').config({ path: 'config/.env' });
const SERVER_URI = process.env.SERVER_URI;
const GMAIL_APP_PASSWORD = process.env.GMAIL_APP_PASSWORD;

async function sendResetPasswordMail(email, code) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'elpma.res@gmail.com',
            pass: GMAIL_APP_PASSWORD
        }
    });

    const mailOptions = {
        from: 'mail@omelet.im',
        to: email,
        subject: 'Omelet - 重置密碼申請',
        html: `<h1>Omelet - 重置密碼申請</h1><p>我們收到您重置密碼的申請。<br>若您並未請求重置密碼，請忽略此郵件。<br>若您要重設密碼，請點擊下方藍字並按照網頁中的指示操作。</p><a href="${SERVER_URI}confirm-reset-email?code=${code}">按我重置密碼<a>`
    };

    transporter.sendMail(mailOptions);
}

async function sendRegisterMail(email, code) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'elpma.res@gmail.com',
            pass: GMAIL_APP_PASSWORD
        }
    });

    const mailOptions = {
        from: 'mail@omelet.im',
        to: email,
        subject: 'Omelet - 帳號註冊',
        html: `<h1>Omelet - 帳號註冊</h1><p>我們收到您帳號註冊的申請。<br>若您並未請求註冊帳號，請忽略此郵件。<br>若您要註冊帳號，請點擊下方藍字並按照網頁中的指示操作。</p><a href="${SERVER_URI}confirm-register-email?code=${code}">按我註冊帳號<a>`
    };

    transporter.sendMail(mailOptions);
}

module.exports = { sendResetPasswordMail, sendRegisterMail };