import OpenAI from 'openai';
const openai = new OpenAI({
  apiKey: '', // defaults to process.env["OPENAI_API_KEY"]
});

console.log("選擇回復語氣：");
console.log("1. happy");
console.log("2. anger");
console.log("3. sad");
console.log("4.surprise");
console.log("5. Disgusted");
console.log("6. shy");

function conversation_history(conversation){
//  if (conversation = " "){
//     return "";
//  }
 return conversation;

}

// 宣告一個名為getRole的函式，接收一個參數userChoice
function getRole(userChoice) {
    // 宣告一個變數Role，用來儲存角色名稱
    let Role;
  
    // 使用switch語句來根據userChoice的值來賦值給Role
    switch (userChoice) {
      case "1":
        // 當userChoice等於"1"時，將Role賦值為"happy"
        Role = "happy";
        break;
      case "2":
        // 當userChoice等於"2"時，將Role賦值為"anger"
        Role = "anger";
        break;
      case "3":
        // 當userChoice等於"3"時，將Role賦值為"sad"
        Role = "sad";
        break;
      case "4":    
        Role = "surprise";
          break;
            // 當userChoice等於"4"時，將Role賦值為"surprise"
       case "5":
            Role = "Disgusted";
        break;
          // 當userChoice等於"5"時，將Role賦值為"Disgusted"
      case "6":   
          Role = "shy";
          break;
          // 當userChoice等於"6"時，將Role賦值為"shy"
      default:
        // 當userChoice不等於任何預期的值時，將Role賦值為"未知"
        
        Role = "無效的選擇。請輸入有效的選擇。";
    }
  
    // 回傳Role的值
    return Role;
  }
  

async function main() {
    let myRole = getRole("1");//串接回復模式選擇
    let history = conversation_history("你晚餐要吃什麼?");//串接抓取到的訊息
    console.log(history);
    console.log(myRole); // 顯示回傳的值
    const stream = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',//使用gpt-3.5-turbo模型
      messages: [{ role: "system", content: `Use this ${myRole} tone to respond .`},//傳給gpt的自訂指令
      { role: "system", content: `Give me three different responses.`},
      { role: "system", content: `every responses only Maximum 50 characters.`},
      { role: 'user', content: `read this conversation${history} and Respond to appropriate sentences in same languages`}],//傳送抓取到的訊息
      max_tokens:90,
      stream: true,
      
    });
    for await (const part of stream) {
      process.stdout.write(part.choices[0]?.delta?.content || '');
      process.stdout.write(part.choices[1]?.delta?.content || '');
      process.stdout.write(part.choices[2]?.delta?.content || '');//gpt所回傳的3種回復
    }
  }
  
  
  main();