import OpenAI from 'openai';
const openai = new OpenAI({
  apiKey: 'sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', //輸入所使用的chat_gptAPIkey
});

console.log("選擇回復個性：");
console.log("1. 暴躁的老人");
console.log("2. 溫柔的女人");
console.log("3. 平常的上班族");

function conversation_history(conversation){
//  if (conversation = " "){
//     return "";
//  }
 return conversation;

}//串街後過濾字詞用

// 宣告一個名為getRole的函式，接收一個參數userChoice
function getRole(userChoice) {
    // 宣告一個變數Role，用來儲存角色名稱
    let Role;
  
    // 使用switch語句來根據userChoice的值來賦值給Role
    switch (userChoice) {
      case "1":
        // 當userChoice等於"1"時，將Role賦值為"暴躁的老人"
        Role = "grumpy old man";
        break;
      case "2":
        // 當userChoice等於"2"時，將Role賦值為"溫柔的護士"
        Role = "gentle nurse";
        break;
      case "3":
        // 當userChoice等於"3"時，將Role賦值為"上班族"
        Role = "Ordinary office workers";
        break;
      default:
        // 當userChoice不等於任何預期的值時，將Role賦值為"未知"
        
        Role = "無效的選擇。請輸入有效的選擇。";
    }
  
    // 回傳Role的值
    return Role;
  }
  

async function main() {
    let myRole = getRole("2");//串接角色選擇
    let history = conversation_history("晚餐要吃甚麼");//串接訊息
    console.log(history);
    console.log(myRole); // 顯示回傳的值
    const stream = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: [{ role: "system", content: `You are playing the role of ${myRole}.`},
      { role: "system", content: `Give me three different responses.`},
      { role: "system", content: `every responses only Maximum 50 characters.`},
      { role: 'user', content: `read this conversation${history} and Respond to appropriate sentences in same languages`}],
      max_tokens:90,
      stream: true,
      
    });
    for await (const part of stream) {
      process.stdout.write(part.choices[0]?.delta?.content || '');
      process.stdout.write(part.choices[1]?.delta?.content || '');
      process.stdout.write(part.choices[2]?.delta?.content || '');//輸出三個結果
    }
  }
  
  
  main();