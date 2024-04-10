const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const OpenAI = require('openai');
require('dotenv').config({ path: 'config/.env' });
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const openai = new OpenAI({
    apiKey: OPENAI_API_KEY,
});

function getRole(userChoice) {
    let Role;
    switch (userChoice) {
    case '1':
        Role = 'happy';
        break;
    case '2':
        Role = 'anger';
        break;
    case '3':
        Role = 'sad';
        break;
    case '4':
        Role = 'surprise';
        break;
    case '5':
        Role = 'Disgusted';
        break;
    case '6':
        Role = 'shy';
        break;
    default:
        Role = null;
    }

    return Role;
}

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let ourUid = decodedToken._uid;

    let tone = req.body.tone;
    let msg = req.body.msg;

    let myRole = getRole(tone);//串接回復模式選擇
    console.log(myRole); // 顯示回傳的值
    const resp = await openai.chat.completions.create({
        model: 'gpt-3.5-turbo',//使用gpt-3.5-turbo模型
        messages: [
            { role: 'system', content: `Use this ${myRole} tone to respond` },
            { role: 'system', content: 'Every responses do not exceed 50 characters' },
            { role: 'user', content: `Read this conversation ${msg} and Respond to appropriate sentences in zh-TW` }
        ],
        max_tokens: 160,
        stream: false,
        n: 3
    });

    let replyText0 = resp.choices[0]?.message?.content || '';
    let replyText1 = resp.choices[1]?.message?.content || '';
    let replyText2 = resp.choices[2]?.message?.content || '';

    console.log(`[getGptResp] 推薦回覆： ${[replyText0, replyText1, replyText2]}`);


    try {
        res.status(200).json({
            message: '成功取得推薦回覆',
            data: [replyText0, replyText1, replyText2],
            token: null
        });
    }
    catch (err) {
        res.status(500).json({
            message: `後端發生例外錯誤： ${err.message}`,
            data: null,
            token: null
        });
    }
});

module.exports = router;