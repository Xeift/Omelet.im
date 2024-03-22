import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omelet/componets/button/on_send_msg_btn_pressed.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/componets/message/glow_bar.dart';
import 'package:omelet/message/safe_msg_store.dart';
import 'package:omelet/theme/theme_constants.dart';
// import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:omelet/api/post/login_api.dart';
import 'package:omelet/models/message_data.dart';
import 'package:omelet/utils/get_user_uid.dart';

// TODO: 需要修改遠端 UID

String remoteUid = '552415467919118336'; // xeift

// String remoteUid = '551338674692820992'; // np

class ChatRoomPage extends StatelessWidget {
  static Route route(MessageData data) => MaterialPageRoute(
      builder: (context) => ChatRoomPage(
            messageData: data,
          ));

  const ChatRoomPage({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0).withAlpha(30),
        title: AppBarTitle(
          messageData: messageData,
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            child: ReadMessageList(),
          ),
          _ActionBar(
            messageData: messageData,
          ),
        ],
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key, required this.messageData}) : super(key: key);
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar.small(
          url: messageData.profilePicture,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                messageData.senderName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//測試用list
// List<Map<String, dynamic>> msgs = [
//   {
//     'timestamp': 1709969515576,
//     'type': 'text',
//     'receiver': 551338674692820992,
//     'sender': 552415467919118336,
//     'content': '早安'
//   },

// 測試：檢查是否有訊息

class ReadMessageList extends StatefulWidget {
  const ReadMessageList({Key? key}) : super(key: key);
  @override
  State<ReadMessageList> createState() => _ReadMessageListState();
}

class _ReadMessageListState extends State<ReadMessageList> {
  final SafeMsgStore safeMsgStore = SafeMsgStore();

  List<Map<String, dynamic>> realMsg = []; // 將 realMsg 定義在狀態中保存訊息
  Future<List<Map<String, dynamic>>> fetchAndDisplayMessages() async {
    List<String> messages = await safeMsgStore.readAllMsg(remoteUid);
    if (messages.isNotEmpty) {
      List<Map<String, dynamic>> parsedMessages = messages
          .map((message) => jsonDecode(message))
          .toList()
          .cast<Map<String, dynamic>>();
      print('[chat_room_page.dart]抓取內存訊息{$parsedMessages}');
      return parsedMessages;
    } else {
      print('[chat_room_page.dart]沒有訊息資料');
      return []; // 添加一個默認返回值，例如空列表
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchAndDisplayMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 在等待時顯示進度指示器
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('無訊息');
        }
        List<Map<String, dynamic>> realMsg = snapshot.data!;

        // 按時間先後順序對訊息進行排序
        realMsg.sort((a, b) {
          int timestampA = int.parse(a['timestamp']);
          int timestampB = int.parse(b['timestamp']);
          return timestampA.compareTo(timestampB);
        });

        return ListView.builder(
          itemCount: realMsg.length,
          itemBuilder: (context, index) {
            final realmessage = realMsg[index];
            int timestamp = int.parse(realmessage['timestamp']);
            final isOwnMessage = realmessage['sender'].toString() != ourUid;
            return isOwnMessage
                ? MessageTitle(
                    message: realmessage['content'],
                    messageDate: DateFormat('h:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(timestamp),
                    ),
                  )
                : MessageOwnTitle(
                    message: realmessage['content'],
                    messageDate: DateFormat('h:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(timestamp),
                    ),
                  );
          },
        );
      },
    );
  }
}

class MessageTitle extends StatelessWidget {
  const MessageTitle(
      {Key? key, required this.message, required this.messageDate})
      : super(key: key);

  final String message;
  final String messageDate;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(_borderRadius),
                      topRight: Radius.circular(_borderRadius),
                      bottomRight: Radius.circular(_borderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20),
                    child: Text(message),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(messageDate,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
        ));
  }
}

class MessageOwnTitle extends StatelessWidget {
  const MessageOwnTitle(
      {Key? key, required this.message, required this.messageDate})
      : super(key: key);

  final String message;
  final String messageDate;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_borderRadius),
                      bottomRight: Radius.circular(_borderRadius),
                      bottomLeft: Radius.circular(_borderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Text(message,
                        style: const TextStyle(
                          color: AppColors.textLigth,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(messageDate,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
        ));
  }
}

class DateLable extends StatelessWidget {
  const DateLable({Key? key, required this.lable}) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(lable,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )))),
    ));
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar({Key? key, required this.messageData}) : super(key: key);
  final MessageData messageData;

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  late TextEditingController sendMsg;
  @override
  _ActionBarState() {
    sendMsg = TextEditingController();
  }
  @override
  void initState() {
    super.initState();
    sendMsg = TextEditingController();
    sendMsg.addListener(_onTextChange);
  }

  Timer? _debounce;

  Future<void> _sendMessage() async {
    if (sendMsg.text.trim().isNotEmpty) {
      print('[chat_room_page]以下是所有訊息');
      print(sendMsg.text);
      print('[chat_room_page]對方的uid $remoteUid');
      onSendMsgBtnPressed(remoteUid, sendMsg.text);
      print('[chat_room_page]準備刪除輸入匡訊息');
      sendMsg.clear();
      FocusScope.of(context).unfocus();
      print('[chat_room_page]刪除完畢');
    }
  }

  void _onTextChange() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (mounted) {}
    });
  }

  @override
  void dispose() {
    sendMsg.removeListener(_onTextChange);
    super.dispose();
    sendMsg.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Row(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                CupertinoIcons.bars,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                onChanged: (val) {
                  sendMsg.text = val;
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 20,
            ),
            child: GlowingActionButton(
              color: const Color.fromARGB(255, 0, 0, 0),
              icon: Icons.send_rounded,
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
