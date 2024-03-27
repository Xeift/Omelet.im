import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/post/remove_friend_api.dart';
import 'package:omelet/api/post/reply_friend_request_api.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/models/message_data.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/message/safe_notify_store.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final SafeNotifyStore safeNotifyStore = SafeNotifyStore();

  Future<List<Map<String, dynamic>>> fetchAndDisplayNotifications() async {
    List messages = await safeNotifyStore.readAllNotifications();
    if (messages.isNotEmpty) {
      return [];
    } else {
      print('[notification_page.dart]沒有通知資料');
      return []; // Adding a default return value, for example, an empty list
    }
  }

  Future<void> _sendFriendsAccept() async {
    replyFriendRequestApi('552415467919118336', true);
    print('已成為好友');
  }

  Future<void> _removeFriends() async {
    removeFriendApi('552415467919118336');
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
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child:Column(children: [
              ElevatedButton(
              onPressed: () async {
                _sendFriendsAccept();
              },
              child: Text('no'),
            ),
            ElevatedButton(
              onPressed: () async {
                _removeFriends();
              },
              child: Text('delet'),
            ),
            ],
            
            )
            
          );
        }
        List<Map<String, dynamic>> realMsg = snapshot.data!;
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            // Here you need to return a widget based on realMsg[index]
          },
        );
      },
    );
  }
}

class MessageItemTitle extends StatelessWidget {
  const MessageItemTitle({Key? key, required this.messageData})
      : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle onTap action here, if needed
      },
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.medium(url: messageData.profilePicture),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageData.senderName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        letterSpacing: 0.2,
                        wordSpacing: 1.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        messageData.message,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
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
}
