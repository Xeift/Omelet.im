const { Snowflake } = require('@sapphire/snowflake');
const epoch = new Date('2020-01-01T00:00:00.000Z');
const snowflake = new Snowflake(epoch);

function generateId() {
    const id = snowflake.generate().toString();
    return id;
}

function extractTimeStampFromId(_id) {
    const timestamp = parseInt(snowflake.deconstruct(_id).timestamp);
    return timestamp;
}

module.exports = {
    generateId,
    extractTimeStampFromId
};