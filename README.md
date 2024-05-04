# Omelet.im
蛋餅 Omelet - 端對端加密即時通訊軟體

## 使用方法

### 後端伺服器
1. npm i
2. node server.js（本地測試） 或 node aws_server.js（AWS 部署）

### Flutter 客戶端
1. flutter pub get

## 資料夾介紹
主要分為 backend 與 client 資料夾，backend 為後端伺服器，client 為 flutter 客戶端 App。

```
Omelet-Social-Platform
├──.vscode                      工作區設定
│
├──backend                      後端資料夾
│       ├──api                  所有後端 API 的 JS 檔案
│       │    ├──get             GET API
│       │    └──post            POST API
│       │
│       ├──config               放 .env（環境變數）的地方
│       ├──controller           MongoDB 控制器
│       ├──model                MongoDB 模型
│       ├──node_modules         安裝的函式庫都存在這，沒事不會特別動
│       ├──pfp                  放使用者上傳的頭像
│       ├──utils                一些雜七雜八的 JS 檔案，後端會用到
│       ├──.eslintrc.json       js 的 linter 規則
│       ├──package-lock.json    記錄用了哪些函式庫，還有 函式庫用了哪些其他的函式庫
│       ├──package.json         記錄用了哪些函式庫
│       └──server.js            後端主程式
│
├──client                       Flutter 客戶端資料夾
│       ├──omelet               主要客戶端程式
│       ├──sample_im            測試用客戶端程式
│       ├──single_acc_im        測試用客戶端程式
│       ├──xeift_e2ee_test      用於測試通訊、API
│       └──test_im_v4           目前最新的測試用客戶端
│
├──.gitignore                   gitignore設定文件
├──LICENSE                      版權宣告
└──README.md                    此檔案
```