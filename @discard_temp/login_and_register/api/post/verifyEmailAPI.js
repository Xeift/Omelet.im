const mdb = require('../../utils/mongodb.js');
const jwt = require('../../utils/jwt.js');
const email = require('../../utils/email.js');
const isInputEmpty = require('../../utils/isInputEmpty.js');


module.exports = async(req, res) => {
    let emailData = req.body.email;

    if (isInputEmpty(emailData)) {
        res.status(422).json({
            message: 'email輸入不可為空',
            data: null,
            token: null
        });
        return;
    }
    try {
        let isEmailExsists = await mdb.isEmailExsists(emailData);
        if (!isEmailExsists) { 
            let code = await jwt.generateRestorePasswordToken(emailData);
            let resetTempCodeStats = await mdb.saveRegisterTempCode(emailData, code);
            let emailStats = await email.sendRegisterMail(emailData, code);
            if (resetTempCodeStats !== true) {
                res.status(500).json({
                    message: '資料庫異常',
                    data: null,
                    token: null
                });
            }
            else if (emailStats !== true) {
                res.status(500).json({
                    message: 'email 寄送失敗',
                    data: null,
                    token: null
                });                
            }
            else {
                res.status(200).json({
                    message: 'email 已成功寄出',
                    data: null,
                    token: null
                });
            }

        }
        else {
            res.status(401).json({
                message: 'email 已存在',
                data: null,
                token: null
            });
        }
    }
    catch (err) {
        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
        console.log(err);
    }
};