const snowflake = require('node-snowflake').Snowflake;
module.exports = function(){
    return snowflake.nextId();
};