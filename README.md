# Omelet.im
蛋餅 Omelet - 具備高隱私與個人化之創新即時通訊軟體

## 使用方法

1. 確定終端機路徑為 C:\Users\你的使用者名稱\Desktop（我是放在桌面）\social-platform>
2. cd backend （後端） cd frontend （前端）
3. npm i
4. nodemon server.js
5. 在瀏覽器輸入 http://localhost:3001 （前端）或者用 Postman 測試 http://localhost:3000 （後端）

## 資料夾介紹

```
Omelet-Social-Platform
├──.vscode                      工作區設定
│
├──backend                      後端資料夾
│       ├──api                  所有後端API的JS檔案
│       ├──config               放 .env（環境變數）的地方
│       ├──controller           MongoDB控制器
│       ├──model                MongoDB模型
│       ├──node_modules         安裝的函式庫都存在這，沒事不會特別動
│       ├──utils                一些雜七雜八的 JS 檔案，後端會用到
│       ├──package-lock.json    記錄用了哪些函式庫，還有 函式庫用了哪些其他的函式庫
│       ├──package.json         記錄用了哪些函式庫
│       └──server.js            後端主程式
│
├──client                       Flutter 客戶端資料夾
│       ├──omelet               主要客戶端程式
│       └──xeift_e2ee_test      用於測試通訊、API
│
├──frontend                     前端資料夾（Web 客戶端已棄用，轉為 Flutter）
│       ├──node_modules         安裝的函式庫都存在這，沒事不會特別動
│       ├──route                單純GET前端網頁的API
│       ├──view                 前端Html、CSS檔案
│       ├──package-lock.json    記錄用了哪些函式庫，還有 函式庫用了哪些其他的函式庫
│       ├──package.json         記錄用了哪些函式庫
│       └──server.js            前端主程式
│
├──.eslintrc.json               ESLint設定文件
├──.gitignore                   gitignore設定文件
├──LICENSE                      版權宣告
└──README.md                    此檔案
```