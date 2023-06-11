const express = require('express');
const app = express();
app.use(express.static('client'))
const server = require('http').Server(app);
const io = require('socket.io')(server);
const records = require('./record.js');  // 記錄歷史訊息


let onlineCount = 0;

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/../client/index.html') // 首頁
});

io.on('connection', (socket) => { // 當成員連線
    onlineCount++;
    io.emit('online', onlineCount); // 發送人數給 client
    socket.emit('maxRecord', records.getMax()); // 人數最大值
    socket.emit('chatRecord', records.get()); // 聊天記錄
    socket.on('send', (msg) => {
        if (Object.keys(msg).length < 2) return;
        records.push(msg);
    });

    socket.on('disconnect', () => { // 當成員離線
        onlineCount = (onlineCount < 0) ? 0 : onlineCount-=1;
        io.emit('online', onlineCount);
    });
});

records.on('new_message', (msg) => {
    // 廣播訊息到聊天室
    io.emit('msg', msg);
});

server.listen(3000, () => {
    console.log('Server Started. http://localhost:' + 3000);
});
