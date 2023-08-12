const mdb = require('../../utils/mongodb.js');
const jwt = require('../../utils/jwt.js');
const isInputEmpty = require('../../utils/isInputEmpty.js');


module.exports = async(req, res) => {
    let username = req.body.username;
    let password = req.body.password;

    if (isInputEmpty(username) || isInputEmpty(password)) {
        res.status(422).json({
            message: '輸入不可為空',
            data: null,
            token: null
        });
        return;
    }
    try {
        let user = await mdb.isPasswordMatch(username, password); // verify password

        if (user) { // username and password match
            let userid = await mdb.findIdByUsername(username); // get userid
            let token = await jwt.generateLoginJWT(userid, username); // generate jwt
            res.status(200).json({ // return token to client
                message: '登入成功',
                data: null,
                token: token
            });
        }
        else { // username and password not match
            let isUserExsists = await mdb.isUserExsists(username);
            res.status(401).json({
                message: '帳號或密碼錯誤',
                data: { isUserExsists: isUserExsists },
                token: null
            });
        }
    }
    catch (err) { // error handle
        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
    }
};