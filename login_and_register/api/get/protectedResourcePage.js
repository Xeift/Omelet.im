module.exports = (req, res) => {
    const decodedToken = req.user; // decoded jwt
    console.log(`[protectedResourcepage.js]\n${decodedToken}\n`);
    res.send({ 'decodedToken': decodedToken }); // TODO:
};