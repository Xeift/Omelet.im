const express = require('express');
const app = express();
app.use(express.static('client'))
const server = require('http').Server(app);
const io = require('socket.io')(server);
const records = require('./record.js');  // 記錄歷史訊息

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/../client/index.html') // 首頁
});

io.on('connection', (socket) => { // 當成員連線
    socket.emit('chatRecord', records.get()); // 取得聊天記錄
    socket.on('send', (msg) => { // 當成員發送訊息
        if (Object.keys(msg).length < 2) return;
        records.push(msg);
    });

    socket.on('disconnect', () => { // 當成員離線
        console.log('member disconnected');
    });
});

records.on('new_message', (msg) => {
    io.emit('msg', msg); // 廣播訊息到聊天室
});

server.listen(3000, () => {
    console.log('Server Started. http://localhost:' + 3000);
});
