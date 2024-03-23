const FriendRequestModel = require('../model/friendRequestModel');
const VerifiedUserModel = require('../model/verifiedUserModel');

/*----------------------------------------------------------------
                                管理好友
----------------------------------------------------------------*/

// 新增好友
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

// 移除好友
async function removeFriend(user1Uid, user2Uid) {
    await VerifiedUserModel.findOneAndUpdate(
        { uid: user1Uid },
        { $pull: { friends: user2Uid } }
    );
    await VerifiedUserModel.findOneAndUpdate(
        { uid: user2Uid },
        { $pull: { friends: user1Uid } }
    );
}

// 查看好友列表
async function getFriendsList(uid) {
    const user = await VerifiedUserModel.findOne({ uid: uid });
    return user ? user.friends : [];
}

/*----------------------------------------------------------------
                                管理好友邀請
----------------------------------------------------------------*/

// 傳送好友邀請
async function sendFriendRequest(initiatorUid, targetUid) {
    
    // 檢查彼此是否已為好友
    const initiatorFriends = await getFriendsList(initiatorUid);
    if (initiatorFriends.includes(targetUid)) {
        return 'already_friend';
    }

    // 檢查是否重複發送好友邀請
    const existingRequest = await FriendRequestModel.findOne({ initiatorUid: initiatorUid, targetUid: targetUid });
    if (existingRequest) {
        return 'duplicate_friend_req';
    }

    const friendRequest = new FriendRequestModel({
        initiatorUid: initiatorUid,
        targetUid: targetUid,
        timestamp: Date.now(),
    });
    await friendRequest.save();

    return 'success';
}

// 移除好友邀請
async function removeFriendRequest(initiatorUid, targetUid) {
    await FriendRequestModel.deleteOne({ initiatorUid: initiatorUid, targetUid: targetUid });
}

// 取得好友邀請
async function getFriendRequest(targetUid) {
    const friendRequests = await FriendRequestModel.find({ targetUid: targetUid }, { _id: 0, __v: 0 });
    return friendRequests;
}

module.exports = {
    addFriend,
    removeFriend,
    getFriendsList,
    sendFriendRequest,
    removeFriendRequest,
    getFriendRequest
};