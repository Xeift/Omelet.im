const path = require('path');


module.exports = (req, res) => {
    res.sendFile(path.join(__dirname, '../view/msg_test/msg_test.html'));
};