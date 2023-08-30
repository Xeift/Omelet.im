const nodemailer = require('nodemailer');
require('dotenv').config({ path: 'config/.env' });
const GMAIL_APP_PASSWORD = process.env.GMAIL_APP_PASSWORD;
const FRONTEND_URL = process.env.FRONTEND_URL;

async function sendResetPasswordMail(email, code) {
    try {
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
            html: `<h1>Omelet - 重置密碼申請</h1><p>我們收到您重置密碼的申請。<br>若您並未請求重置密碼，請忽略此郵件。<br>若您要重設密碼，請點擊下方藍字並按照網頁中的指示操作。</p><a href="${FRONTEND_URL}update-password?code=${code}">按我重置密碼<a>`
        };
        
        transporter.sendMail(mailOptions);
    }
    catch (err) {
        console.log(err);
        return false;
    }
    return true;
}

async function sendRegisterMail(email, code) {
    try {
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
            subject: 'Omelet - 帳號註冊',
            html: `<h1>Omelet - 帳號註冊</h1><p>我們收到您帳號註冊的申請。<br>若您並未請求註冊帳號，請忽略此郵件。<br>若您要註冊帳號，請點擊下方藍字並按照網頁中的指示操作。</p><a href="https://localhost:3000/register?code=${code}">按我註冊帳號<a>`
        };
        
        transporter.sendMail(mailOptions);
    }
    catch (err) {
        console.log(err);
        return false;
    }
    return true;
}

module.exports = { sendResetPasswordMail, sendRegisterMail };