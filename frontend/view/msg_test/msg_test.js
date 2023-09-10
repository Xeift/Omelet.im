var socket = io('http://localhost:3000');
// 監聽事件和發送訊息
socket.on('connect', function(){
    console.log('已連接到後端');
    socket.emit('hello', '你好，我是前端');
});
socket.on('message', function(msg){
    console.log('收到後端的訊息：' + msg);
});
