module.exports = (req, res) => {
    const decodedToken = req.user; // decoded jwt
    console.log(decodedToken);
    res.send({ 'decodedToken': decodedToken }); // TODO:
};