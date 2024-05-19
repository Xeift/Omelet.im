const express = require('express');
const router = express.Router();
const jwt = require('../../utils/jwt.js');
const OpenAI = require('openai');
require('dotenv').config({ path: 'config/.env' });
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const openai = new OpenAI({
    apiKey: OPENAI_API_KEY,
});

router.post('/', jwt.verifyJWT, async(req, res) => {
    let decodedToken = req.decodedToken;
    let msg = req.body.msg;
    let destLang = req.body.destLang;

    console.log(msg);

    const resp = await openai.chat.completions.create({
        model: 'gpt-3.5-turbo',
        messages: [
            { role: 'system', content: 'You are now a translation robot and cannot reply to other questions except the translated content.' },
            { role: 'system', content: `Translate "${msg}" to "${destLang}" and keep the original intention without adding redundant content` }, 
            { role: 'system', content: 'The reply content can only contain content that needs to be translated.' },  
            { role: 'system', content: 'This translation must be more colloquial,but should not deviate from the original meaning.' },
            { role: 'assistant', content: `If the original text and target language are the same, just send back the ${msg} without translating.` }
        ],
        max_tokens: 160,
        stream: false,
    });

    let translatedText = resp['choices'][0]['message']['content'];
    console.log(`[getTranslatedSentence.js] 譯文：${translatedText}`);

    try {
        res.status(200).json({
            message: '翻譯完畢',
            data: translatedText,
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
