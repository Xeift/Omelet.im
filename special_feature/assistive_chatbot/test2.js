// 使用import關鍵字來引入readline模組，並使用await關鍵字來等待模組載入完成
const readline = await import('node:readline');

// 建立一個readline介面，並指定標準輸入和輸出
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// 使用question方法來提示用戶輸入，並將返回值傳遞給一個回呼函式
rl.question('請輸入一個字串：', (answer) => {
  // 在回呼函式中，可以對answer進行判斷和處理
  // 使用trim方法來移除字串前後的空白
  answer = answer.trim();
  // 判斷字串是否為空
  if (answer === '') {
    // 如果為空，則回傳無資料
    console.log('無資料');
  } else {
    // 如果不為空，則回傳用戶輸入的字串
    console.log(`你輸入的字串是：${answer}`);
  }
  // 關閉readline介面
  rl.close();
});
