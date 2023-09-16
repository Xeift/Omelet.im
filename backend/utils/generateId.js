const { Snowflake } = require('@sapphire/snowflake');
const epoch = new Date('2020-01-01T00:00:00.000Z');
const snowflake = new Snowflake(epoch);

module.exports = function() {
    const id = snowflake.generate().toString();
    return id;
};