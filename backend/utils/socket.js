module.exports = function(io) {
    io.on('connection', (socket) => {
        console.log('[utils/socket.js] a user connected');
        socket.emit('message', '後端asdaasfasfsa');
    });
};