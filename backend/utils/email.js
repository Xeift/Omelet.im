const nodemailer = require('nodemailer');
require('../config/config.js');
const AWS_PUBLIC_SERVER_URI = process.env.AWS_PUBLIC_SERVER_URI;
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
        html: `
            <div style="font-family: Arial, sans-serif; color: #000; padding: 20px; border: 2px solid #000;">
                <h1 style="color: #000; font-size: 24px; margin-bottom: 20px;">Omelet - 重置密碼申請</h1>
                <p style="color: #000; font-size: 16px; margin-bottom: 20px;">
                    我們收到您重置密碼的申請。<br>
                    若您並未請求重置密碼，請忽略此郵件。<br>
                    若您要重設密碼，請點擊下方按鈕並按照網頁中的指示操作。
                </p>
                <a href="${AWS_PUBLIC_SERVER_URI}api/v1/reset-password/confirm-reset-email?code=${code}" style="text-decoration: none; display: inline-block; padding: 10px 20px; background-color: #fff; color: #000; border: 2px solid #000; border-radius: 5px; transition: background-color 0.3s, color 0.3s, border-color 0.3s;">
                    按我重置密碼
                </a>
            </div>`
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
        subject: 'Omelet - 註冊帳號',
        html: `
            <div style="font-family: Arial, sans-serif; color: #000; padding: 20px; border: 2px solid #000;">
                <h1 style="color: #000; font-size: 24px; margin-bottom: 20px;">Omelet - 註冊帳號申請</h1>
                <p style="color: #000; font-size: 16px; margin-bottom: 20px;">
                    我們收到您註冊帳號的申請。<br>
                    若您並未請求註冊帳號，請忽略此郵件。<br>
                    若您要註冊帳號，請點擊下方按鈕並按照網頁中的指示操作。
                </p>
                <a href="${AWS_PUBLIC_SERVER_URI}api/v1/register/confirm-register-email?code=${code}" style="text-decoration: none; display: inline-block; padding: 10px 20px; background-color: #fff; color: #000; border: 2px solid #000; border-radius: 5px; transition: background-color 0.3s, color 0.3s, border-color 0.3s;">
                    註冊帳號
                </a>
            </div>`
    };

    transporter.sendMail(mailOptions);
}

module.exports = { sendResetPasswordMail, sendRegisterMail };