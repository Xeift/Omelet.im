# Omelet-Social-Platform
蛋餅 - 創新社交平臺

# login_and_register

登入、註冊、驗證相關功能

## 使用方法

1. 確定終端機路徑為 C:\Users\你的使用者名稱\Desktop（我是放在桌面）\social-platform>
2. cd login_and_register
3. npm i
4. node server.js
5. 在瀏覽器輸入 http://localhost:3000

## 資料夾介紹

`api`
分為 get 與 post，存放所有 API 的 JS 檔案

`client`
前端不同頁面的 Html 和 JS 檔案

`config`
放 .env（環境變數）的地方

`node_modules`
安裝的函式庫都存在這，沒事不會特別動

`utils`
一些雜七雜八的 JS 檔案，後端會用到

`package-lock.json`
記錄用了哪些函式庫，還有 函式庫用了哪些其他的函式庫

`package.json`
記錄用了哪些函式庫

`server.js`
主程式