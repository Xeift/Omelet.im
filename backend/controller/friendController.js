const FriendRequestModel = require('../model/friendRequestModel');
const VerifiedUserModel = require('../model/verifiedUserModel');

async function addFriend(user1Uid, user2Uid) {
    await VerifiedUserModel.findOneAndUpdate(
        { uid: user1Uid },
        { $push: { friends: user2Uid } }
    );
    await VerifiedUserModel.findOneAndUpdate(
        { uid: user2Uid },
        { $push: { friends: user1Uid } }
    );
}

module.exports = {
    addFriend
};