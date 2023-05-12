const express = require('express');
const app = express();
const server = require('http').Server(app);
const io = require('socket.io')(server);

app.use(express.static('website'))

app.get('/', (req, res) => { // 首頁
    res.sendFile(__dirname + '/website/index.html')
})

io.on('connection', (socket) => { // client 連上時執行的程式
    console.log('connected!');

    socket.on('greet', () => { // 2. 接收到 client 事件，回傳 greet 事件
        socket.emit('greet', 'Hi! Client.');
    });

    socket.on('disconnect', () => { // client 中斷連接時執行的程式
        console.log('disconnected!');
    })

    socket.on("send", (msg) => {
        // 如果 msg 內容鍵值小於 2 等於是訊息傳送不完全
        // 因此我們直接 return ，終止函式執行。
        if (Object.keys(msg).length < 2) return;
     
        // 廣播訊息到聊天室
        io.emit("msg", msg);
    });
})


server.listen(3000, () => { // 在 3000 port 上運行伺服器
    console.log('server started on\nhttp://localhost:3000')
})