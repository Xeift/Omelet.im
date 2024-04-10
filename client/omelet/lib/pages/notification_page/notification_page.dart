import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/post/reply_friend_request_api.dart';
import 'package:omelet/storage/safe_notify_store.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final SafeNotifyStore safeNotifyStore = SafeNotifyStore();

  Future<List<Map<String, dynamic>>> fetchAndDisplayNotifications() async {
    List<dynamic> messages = await safeNotifyStore.readAllNotifications();
    List<Map<String, dynamic>> jsonMessages =
        messages.map((message) => message as Map<String, dynamic>).toList();
    if (messages.isNotEmpty) {
      print('[notification_page.dart]通知內容物：$jsonMessages');
      return jsonMessages;
    } else {
      print('[notification_page.dart]沒有通知資料');
      return []; // Adding a default return value, for example, an empty list
    }
  }

  Future<void> _handleRefresh9() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
              onRefresh: _handleRefresh9,
              child: ListView.builder(
                itemCount: realMsg.length,
                itemBuilder: (context, index) {
                  if (realMsg[index]['type'] == 'friend_request') {
                    final String requestUid = realMsg[index]['initiatorUid'];
                    final int requestTime = realMsg[index]['timestamp'];
                    print('[notification_page.dart]realMsg:$realMsg');
                    return FriednsRequestItemTitle(
                      requestTime: requestTime,
                      requestData: realMsg,
                      requestUid: requestUid,
                    );
                  } else if (realMsg[index]['type'] == 'system') {
                  } else {
                    print(
                        '[notification_page.dart] Error type for notification');
                  }
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                '這裡很安靜 (蟬叫.....)，\n'
                '現在沒訊息喔',
                style: TextStyle(
                  fontSize: 15,
                
                ),),
            );
          }
        });
  }
}

class FriednsRequestItemTitle extends StatelessWidget {
  FriednsRequestItemTitle({
    Key? key,
    required this.requestTime,
    required this.requestData,
    required this.requestUid,
  }) : super(key: key);

  final List<Map<String, dynamic>> requestData;
  final String requestUid;
  final int requestTime;

  final SafeNotifyStore safeNotifyStore = SafeNotifyStore();

  Future<Map<String, dynamic>> fetchAndDisplayPublicInfo() async {
    var res = await getUserPublicInfoApi(requestUid);
    String responseBody =
        res.body.toString(); // Convert response body to string
    Map<String, dynamic> resBody = jsonDecode(responseBody);
    print('[notification_page.dart]抓取用戶資料{$resBody}');
    return resBody;
  }

  Future<void> _sendFriendsAccept() async {
    final res = await replyFriendRequestApi(requestUid, true);
    print('[notification_page.dart] ${res.body}');
    print('[notification_page.dart]已成為好友');
    await safeNotifyStore.deleteNotification(requestTime);
    print('[notification_page.dart]訊息列表已刪除 Time:$requestTime');
  }

  Future<void> _sendFriendsDismiss() async {
    final res = await replyFriendRequestApi(requestUid, false);
    print('[notification_page.dart] ${res.body}');
    print('拒絕邀請🥲');
    await safeNotifyStore.deleteNotification(requestTime);
    print('[notification_page.dart]訊息列表已刪除 Time:$requestTime');
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
            print('[notification.dart] username:$username');
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
                                '好友邀請',
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
                          child: const Text('accept')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: _sendFriendsDismiss,
                          child: const Text('Dismiss'))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('錯誤資料，請回報Omelet.im團隊'));
          }
        }
      },
    );
  }
}
