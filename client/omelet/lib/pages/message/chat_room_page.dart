import 'dart:async';
import 'dart:convert';
import 'dart:ui';

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

// String remoteUid = '552415467919118336'; // xeift

// String remoteUid = '551338674692820992'; // np

class ChatRoomPage extends StatefulWidget {
  static Route route(Map<String, dynamic> friendsInfo) => MaterialPageRoute(
      builder: (context) => ChatRoomPage(
            friendsInfo: friendsInfo,
          ));

  const ChatRoomPage({Key? key, required this.friendsInfo}) : super(key: key);
  final Map<String, dynamic> friendsInfo;
  @override
  State<ChatRoomPage> createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  static GlobalKey updateChatKey = GlobalKey();
  static currenInstance() {
    var state = ChatRoomPageState.updateChatKey.currentContext
        ?.findAncestorStateOfType();
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65), // 設定所需的高度
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              title: AppBarTitle(friendsInfo: widget.friendsInfo,),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
            ),
          ),
        ),
      ),
      key: updateChatKey,
      body: Column(
        children: [
          Expanded(
            child: ReadMessageList(friendsInfo: widget.friendsInfo,),
          ),
          _ActionBar(
            friendsInfo: widget.friendsInfo
          ),
        ],
      ),
    );
  }

  reloadData() {
    setState(() {});
    print('[chat_room_page]以刷新頁面');
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key, required this.friendsInfo}) : super(key: key);
  final Map<String, dynamic> friendsInfo;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar.small(
        //   url: messageData.profilePicture,
        // ),
        const Icon(Icons.ac_unit_outlined),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friendsInfo['data']['username'],
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

class ReadMessageList extends StatelessWidget {
  final SafeMsgStore safeMsgStore = SafeMsgStore();
  

  ReadMessageList({super.key, required this.friendsInfo});
  final Map<String, dynamic> friendsInfo;

  Future<List<Map<String, dynamic>>> fetchAndDisplayMessages() async {
    List<String> messages = await safeMsgStore.readAllMsg(friendsInfo['data']['uid']);
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
    print('[chat_room_page.dart]加載一次');
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
          return timestampB.compareTo(timestampA);
        });

        return ListView.builder(
          reverse: true,
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
  const _ActionBar({Key? key, required this.friendsInfo}) : super(key: key);
  final Map<String, dynamic> friendsInfo;

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  late TextEditingController _sendMsgController;

  @override
  void initState() {
    super.initState();
    _sendMsgController = TextEditingController();
  }

  Future<void> _sendMessage() async {
    if (_sendMsgController.text.trim().isNotEmpty) {
      print('[chat_room_page]以下是所有訊息');
      print(_sendMsgController.text);
      print('[chat_room_page]對方的uid ${widget.friendsInfo['data']['uid']}');
      // 使用好友信息发送消息
      onSendMsgBtnPressed(widget.friendsInfo['data']['uid'], _sendMsgController.text);
      setState(() {
        _sendMsgController.clear();
      });
      FocusScope.of(context).unfocus();
      print('[chat_room_page]準備刪除輸入匡訊息');
      print('[chat_room_page]刪除完畢');
    }
  }

  @override
  void dispose() {
    _sendMsgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[chat_room_page.dart]ActionBar被加載');
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
                controller: _sendMsgController,
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
