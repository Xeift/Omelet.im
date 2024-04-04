import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/post/remove_friend_api.dart';
import 'package:omelet/api/post/reply_friend_request_api.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/models/message_data.dart';
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
      return jsonMessages;
    } else {
      print('[notification_page.dart]沒有通知資料');
      return []; // Adding a default return value, for example, an empty list
    }
  }

  Future<void> _sendFriendsAccept() async {
    replyFriendRequestApi('551338674692820992', true);
    print('已成為好友');
  }

  Future<void> _removeFriends() async {
    removeFriendApi('551338674692820992');
    print('已刪除好友');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAndDisplayNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List<Map<String, dynamic>> realMsg = snapshot.data!;
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: realMsg.length,
              itemBuilder: (context, index) {
                if (realMsg[index]['type'] == 'friend_request') {
                  final String requestUid = realMsg[index]['initiatorUid'];
                  return FriednsRequestItemTitle(
                    requestData: realMsg,
                    requestUid: requestUid,
                  );
                } else if (realMsg[index]['type'] == 'system') {
                } else {
                  print('[notification_page.dart] Error type for notification');
                }
              },
            );
          } else {
            return const Center(
              child: Text('[notification_page.dart] you have no message now'),
            );
          }
        });
  }
}

class FriednsRequestItemTitle extends StatelessWidget {
  const FriednsRequestItemTitle(
      {Key? key, required this.requestData, required this.requestUid})
      : super(key: key);
  final List<Map<String, dynamic>> requestData;
  final String requestUid;

  Future<Map<String, dynamic>> fetchAndDisplaPublicInfo() async {
    var res = await getUserPublicInfoApi(requestUid);

    Map<String, dynamic> resBody = jsonDecode(res.body);
    print('[notification_page.dart]抓取用戶資料{$resBody}');
    return resBody;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAndDisplaPublicInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // var requrestUserInfo = snapshot;
            print('[notification_page.dart]snapshot$snapshot');
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
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        // child: Avatar.medium(url: messageData.profilePicture),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '好友申請，請問要接受他的要請嗎？',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                letterSpacing: 0.2,
                                wordSpacing: 1.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Text(
                                'ho',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 162, 162, 162),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
