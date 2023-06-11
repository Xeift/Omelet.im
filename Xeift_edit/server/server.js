const express = require('express');
const app = express();
app.use(express.static('client'))
const server = require('http').Server(app);
const io = require('socket.io')(server);
const records = require('./record.js');  // 記錄歷史訊息

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/../client/index.html') // 首頁
});

io.on('connection', (socket) => { // 1當成員連線
    socket.emit('chatRecord', records.get()); // 2取得聊天記錄
    socket.on('send', (msg) => { // 5收到 emit send event
        if (Object.keys(msg).length < 2) return;
        records.push(msg); // 6將新訊息加進records
    });

    socket.on('disconnect', () => { // 當成員離線
        console.log('member disconnected');
    });
});

records.on('new_message', (msg) => { // 8當收到new_message event(record.js)
    io.emit('msg', msg); // 9emit msg event
});

server.listen(3000, () => {
    console.log('Server Started. http://localhost:3000');
});
