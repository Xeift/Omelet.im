import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/post/reply_friend_request_api.dart';
import 'package:omelet/storage/safe_notify_store.dart';
import 'package:omelet/utils/check_device_id.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.ourUid}) : super(key: key);
  final String ourUid;
  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  final SafeNotifyStore safeNotifyStore = SafeNotifyStore();
  static GlobalKey updateNotiKey = GlobalKey();

  Future<void> handleRefresh9() async {
    await fetchAndDisplayNotifications();
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayNotifications() async {
    List<dynamic> messages = await safeNotifyStore.readAllNotifications();
    List<Map<String, dynamic>> jsonMessages =
        messages.map((message) => message as Map<String, dynamic>).toList();
    if (messages.isNotEmpty) {
      return jsonMessages;
    } else {
      return []; // Adding a default return value, for example, an empty list
    }
  }

  static currenInstanceForNoti() {
    var state = NotificationPageState.updateNotiKey.currentContext
        ?.findAncestorStateOfType();

    return state;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: handleRefresh9,
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchAndDisplayNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Color.fromARGB(255, 240, 118, 36)),
              );
            }
            List<Map<String, dynamic>> realMsg = snapshot.data ?? [];
            if (snapshot.hasData && realMsg.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: handleRefresh9,
                child: ListView.builder(
                  itemCount: realMsg.length,
                  itemBuilder: (context, index) {
                    if (realMsg[index]['type'] == 'friend_request') {
                      final String requestUid = realMsg[index]['initiatorUid'];
                      final int requestTime = realMsg[index]['timestamp'];
                      return FriednsRequestItemTitle(
                        requestTime: requestTime,
                        requestData: realMsg,
                        requestUid: requestUid,
                        onAccept: () {
                          setState(() {});
                        },
                        onDismiss: () {
                          setState(() {});
                        },
                      );
                    } else if (realMsg[index]['type'] == 'system') {
                    } else if (realMsg[index]['type'] == 'system_notify') {
                      final String requestUid = realMsg[index]['targetUid'];
                      final int requestTime = realMsg[index]['timestamp'];

                      return SystemNotify(
                        senderUid: requestUid,
                        sendTime: requestTime,
                        onDelete: () {
                          setState(() {});
                        },
                      );
                    }
                    return null;
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: handleRefresh9,
                child: const Center(
                  child: Text(
                    ' It\'s very quiet here',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  reloadDataNoti() async {
    setState(() {});
  }
}

class FriednsRequestItemTitle extends StatelessWidget {
  final List<Map<String, dynamic>> requestData;
  final String requestUid;
  final int requestTime;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  FriednsRequestItemTitle({
    Key? key,
    required this.requestTime,
    required this.requestData,
    required this.requestUid,
    required this.onAccept,
    required this.onDismiss,
  }) : super(key: key);

  final SafeNotifyStore safeNotifyStore = SafeNotifyStore();

  Future<Map<String, dynamic>> fetchAndDisplayPublicInfo() async {
    var res = await getUserPublicInfoApi(requestUid);
    String responseBody =
        res.body.toString(); // Convert response body to string
    Map<String, dynamic> resBody = jsonDecode(responseBody);
    return resBody;
  }

  Future<void> _sendFriendsAccept() async {
    await replyFriendRequestApi(requestUid, true);
    await safeNotifyStore.deleteNotification(requestTime);
    // 更新裝置 id 資訊並儲存到本地
    await checkDeviceId();
    onAccept();
  }

  Future<void> _sendFriendsDismiss() async {
    await replyFriendRequestApi(requestUid, false);
    await safeNotifyStore.deleteNotification(requestTime);
    onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAndDisplayPublicInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(Color.fromARGB(255, 240, 118, 36)),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Map<String, dynamic>? data = snapshot.data;
          if (data != null) {
            String username = data['data']['username'].toString();
            return InkWell(
              child: Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        // child: Avatar.medium(url: messageData.profilePicture),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                letterSpacing: 0.2,
                                wordSpacing: 1.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Friend Request',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 162, 162, 162),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _sendFriendsAccept,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 111, 34)),
                        child: const Text('Accept'),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: _sendFriendsDismiss,
                        child: const Text('Dismiss'),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child: Text('Error, please report to the Omelet.im team.'));
          }
        }
      },
    );
  }
}

class SystemNotify extends StatelessWidget {
  SystemNotify({
    super.key,
    required this.senderUid,
    required this.sendTime,
    required this.onDelete,
  });

  final String senderUid;
  final int sendTime;
  final VoidCallback onDelete;
  final SafeNotifyStore safeNotifyStore = SafeNotifyStore();

  Future<Map<String, dynamic>> fetchAndDisplayPublicInfo() async {
    try {
      var res = await getUserPublicInfoApi(senderUid);
      String responseBody = res.body.toString();
      Map<String, dynamic> resBody = jsonDecode(responseBody);
      return resBody;
    } catch (e) {
      print('[notification_page.dart]獲取用戶資料失敗: $e');
      rethrow;
    }
  }

  Future<void> _deleteNotification() async {
    try {
      await safeNotifyStore.deleteNotification(sendTime);
      onDelete();
    } catch (e) {
      print('[notification_page.dart] 删除通知失敗: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAndDisplayPublicInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(Color.fromARGB(255, 240, 118, 36)),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Map<String, dynamic>? data = snapshot.data;
          if (data != null) {
            String username = data['data']['username'].toString();
            return InkWell(
              child: Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        // child: Avatar.medium(url: messageData.profilePicture),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                letterSpacing: 0.2,
                                wordSpacing: 1.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'has accepted your friend request🎉',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: _deleteNotification,
                        icon: const Icon(Icons.cancel_presentation),
                        color: const Color.fromARGB(255, 236, 106, 59),
                        iconSize: 35,
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child: Text(
                    'Failed to retrieve user information. \n Please contact Omelet team for assistance🧑‍💻👩‍💻'));
          }
        }
      },
    );
  }
}
