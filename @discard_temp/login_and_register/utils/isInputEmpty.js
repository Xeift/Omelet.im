module.exports = (input) => {
    if (input === null || input === undefined) {
        return true;
    }
    else if (input.trim() === '') {
        return true;
    }
    else {
        return false;
    }
};