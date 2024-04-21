import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/storage/safe_util_store.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/models/message_data.dart';
import 'package:omelet/utils/helpers.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key, required this.ourUid}) : super(key: key);

  final String ourUid;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  SafeUtilStore safeUtilStore = SafeUtilStore();
  SafeMsgStore safeMsgStore = SafeMsgStore();
  List<Map<String, dynamic>> isSended = [];

  Map<String, dynamic> lastMsg = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    Map<String, dynamic>? loadedMsg = await _loadIsSendedList();
    if (loadedMsg != null && loadedMsg.isNotEmpty) {
      if (mounted) {
        setState(() {
          lastMsg = loadedMsg;
          print('[message_list_page.dart]lastMsg:$lastMsg');
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _loadIsSendedList() async {
    var resM = await safeMsgStore.getChatList();
    print('[message_list_page.dart]lastMsg:$resM');
    return resM;
  }

  Future<void> _handleRefreshMdgList() async {
    setState(() {});
  }

  Future<bool> _isValidUrl(String url) async {
    if (url.isEmpty) return false; // 確保網址不是空的

    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200; // 如果狀態碼是 200，則視為有效的 URL
    } catch (e) {
      return false; // 發生任何異常時都視為無效的 URL
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[message_list_page] 訊息列表：$lastMsg');
    return RefreshIndicator(
      onRefresh: _handleRefreshMdgList,
      child: lastMsg.isEmpty
          ? const Center(
              child: Text(
                '這裡沒有訊息😮‍💨，\n 建議你可以叫你好友跟你聊聊🫠',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: lastMsg.length,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        backgroundColor: Colors.blueGrey,
                        icon: Icons.delete,
                        label: 'delet friend',
                        onPressed: (context) => _onDeleted(),
                      ),
                    ],
                  ),
                  child: _delegate(context, index),
                );
              },
            ),
    );
  }

  void _onDeleted() {
    //TODO:寫入刪除訊息列的邏輯
  }

  Widget _delegate(BuildContext context, int index) {
    if (lastMsg.isNotEmpty) {
      final List<String> keys = lastMsg.keys.toList();
      final List values = lastMsg.values.toList();

      if (index >= 0 && index < lastMsg.length) {
        final String senderUid = keys[index];
        final Map<String, dynamic> message = values[index];

        // 檢查 message 是否為空
        if (message.containsKey('remoteUserInfo')) {
          final String senderName = message['remoteUserInfo']['username'];
          String messageContent = '';
          final String remoteUid = senderUid;
          final String messageDate = message['message']['timestamp'];

          print('[message_list_page.dart]message:$message');

          if (message['message']['type'] == 'image') {
            messageContent = '[圖片]';
          } else {
            messageContent = message['message']['content'];
          }

          return FutureBuilder<bool>(
            future: _isValidUrl('$serverUri/pfp/$remoteUid.png'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final bool isUrlValid = snapshot.data ?? false;
                return MessageItemTitle(
                  messageData: MessageData(
                    senderName: senderName,
                    message: messageContent,
                    remoteUid: remoteUid,
                    messageDate: DateTime.fromMillisecondsSinceEpoch(
                        int.parse(messageDate)),
                    profilePicture: isUrlValid
                        ? '$serverUri/pfp/$remoteUid.png'
                        : Helpers.randomPictureUrl(),
                  ),
                  ourUid: widget.ourUid,
                );
              } else {
                return const SizedBox(); // 加載中返回空的小部件
              }
            },
          );
        }
      }
    }

    // 如果 lastMsg 為空或 index 不在範圍內，返回一個空的小部件或其他適當的處理方式
    return const SizedBox(); // 添加了明確的返回語句
  }
}

// ignore: must_be_immutable
class MessageItemTitle extends StatelessWidget {
  MessageItemTitle({Key? key, required this.messageData, required this.ourUid})
      : super(key: key);
  final String ourUid;

  final MessageData messageData;
  SafeMsgStore safeMsgStore = SafeMsgStore();
  SafeUtilStore safeUtilStore = SafeUtilStore();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatRoomPage(
                  ourUid: ourUid,
                  friendsUid: messageData.remoteUid,
                )));
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Colors.grey,
            width: 0.2,
          )),
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
              ))
            ],
          ),
        ),
      ),
    );
  }
}
