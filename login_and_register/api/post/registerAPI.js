const jwt = require('jsonwebtoken');
const mdb = require('../../config/mongodb.js');


module.exports = async (req, res) => {
    try {
        const { code, username, password } = req.body;
        const decoded = jwt.verify(code, 'your-secret-key');
        console.log(`[registerAPI.js] 註冊 ${decoded.email} ${username} ${password}`);

        if (!await mdb.isEmailExsists(decoded.email)) {
            let updateStatus = await mdb.createNewUser(decoded.email, username, password); // TODO: 寫入資料庫
            if (updateStatus) {
                res.status(200).json({
                    message: '註冊成功',
                    data: null,
                    token: null
                });
            }
            else {
                res.status(500).json({
                    message: '資料庫異常',
                    data: null,
                    token: null
                });
            }
        }
        else {
            res.status(401).json({
                message: '該 email 已註冊',
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
    }
};