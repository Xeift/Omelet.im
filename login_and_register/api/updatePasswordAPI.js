const express = require('express');
const path = require('path');
const jwt = require('jsonwebtoken');


module.exports = (req, res) => {
    try {
        const { code, password } = req.body;
        const decoded = jwt.verify(code, 'your-secret-key');
        console.log(decoded);
        console.log(decoded.email);
        // Get the user id from the decoded payload // TODO: DB Update pwd
        // const userId = decoded.id;
        // // Find the user by id in the database (use your own logic here)
        // const user = await User.findById(userId);
        // // Check if the user exists
        // if (!user) {
        //     // Send an error response
        //     res.status(404).json({ message: 'User not found' });
        //     return;
        // }
        // // Update the user's password (use your own logic here)
        // await user.updatePassword(password);
        // // Send a success response
        res.status(200).json({ message: 'Password reset successfully' });
    }
    catch (error) {
        // Send an error response
        res.status(500).json({ message: error.message });
    }
};