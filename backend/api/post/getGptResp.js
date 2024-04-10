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

    console.log(tone);
    console.log(msg);
    console.log(OPENAI_API_KEY);

    let myRole = getRole(tone);//串接回復模式選擇
    console.log(myRole); // 顯示回傳的值
    const resp = await openai.chat.completions.create({
        model: 'gpt-3.5-turbo',//使用gpt-3.5-turbo模型
        messages: [
            { role: 'system', content: `Use ${myRole} tone to respond. Response has to be in same language.` },//傳給gpt的自訂指令
            { role: 'system', content: 'Use 3 different standalone sentences to reply to user message. Follow the format of [Sentence1, Sentence2, Sentence3]' },
            // { role: 'system', content: 'Every responses can\'t exceed 50 characters.' },
            { role: 'user', content: `Here is the message: ${msg}` }],//傳送抓取到的訊息
        max_tokens: 160,
        stream: false,
    });

    console.log(JSON.stringify(resp));
    console.log(resp);

    try {
        res.status(200).json({
            message: 'opk 上傳成功',
            data: null,
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