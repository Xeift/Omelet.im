const mongoose = require('mongoose');
require('../config/config.js');
const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(
    MONGO_URI,
    { useNewUrlParser: true, useUnifiedTopology: true }
);

module.exports = mongoose;