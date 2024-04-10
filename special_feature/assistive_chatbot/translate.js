import OpenAI from 'openai';
const openai = new OpenAI({
  apiKey: '', // defaults to process.env["OPENAI_API_KEY"]
});


function conversation_history(conversation){
//  if (conversation = " "){
//     return "";
//  }
 return conversation;

}



async function main() {
    let userlanguage = "繁體中文(zh-tw)";//需要翻譯成的語言
    let history = conversation_history("which command must be entered when a device is configured as an NTP server");//串接需要翻譯的訊息
    console.log(history);
    console.log(userlanguage); // 顯示回傳的值
    const stream = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',//使用gpt-3.5-turbo模型 
      messages: [  
      { role: "system", content: `You are now a translation robot and cannot reply to other questions except the translated content.`},//傳給gpt的自訂指令
      { role: "system", content: `Translate ${history} conversation into ${userlanguage},and keep the original intention without adding redundant content`}, 
      { role: "system", content: `The reply content can only contain content that needs to be+ translated.`},
      { role: 'system', content: `This translation must be more colloquial,but should not deviate from the original meaning.`}],//傳送抓取到的訊息]
      max_tokens:90,
      stream: true,
      
    });
    for await (const part of stream) {
      process.stdout.write(part.choices[0]?.delta?.content || '');
    }
  }
  
  
  main();