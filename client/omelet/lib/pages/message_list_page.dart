import 'package:flutter/material.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/nav_bar_control_page.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/storage/safe_util_store.dart';
// import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/message_data.dart';
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


  Map<String, dynamic> leastMsg = {};

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
          leastMsg = loadedMsg;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _loadIsSendedList() async {
    var resM = await safeMsgStore.getChatList();
    print('[message_list_page.dart]leastMsg:$resM');
    return resM;
  }

  Future<void> _handleRefreshMdgList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('[message_list_page] 訊息列表：$leastMsg');
    return RefreshIndicator(
      onRefresh: _handleRefreshMdgList,
      child: ListView.builder(
        itemCount: leastMsg.length,
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
                      onPressed: (context) => _onDeleted()),
                ],
              ),
              child: _delegate(context, index));
        },
      ),
    );
  }

  void _onDeleted() {
    //TODO:寫入刪除訊息列的邏輯
  }

  Widget _delegate(BuildContext context, int index) {
    if (leastMsg.isNotEmpty) {
      final List<String> keys = leastMsg.keys.toList();
      final List values = leastMsg.values.toList();

      if (index >= 0 && index < leastMsg.length) {
        final String senderUid = keys[index];
        final Map<String, dynamic> message = values[index];

        // 檢查 message 是否為空
        if (message.containsKey('remoteUserInfo')) {
          final String senderName = message['remoteUserInfo']['username'];
          String messageContent = '';
          final String remoteUid = senderUid;
          final String messageDate = message['message']['timestamp'];

          print('[message_list_page.dart]message:$message');
          

          if(message['message']['type'] == 'image'){
            messageContent = '圖片';
          }else{
            messageContent = message['message']['content'];
          }

          return MessageItemTitle(
            messageData: MessageData(
              senderName: senderName,
              message: messageContent,
              remoteUid: remoteUid,
              messageDate:
                  DateTime.fromMillisecondsSinceEpoch(int.parse(messageDate)),
              profilePicture: Helpers.randomPictureUrl(),
            ), ourUid: widget.ourUid,
          );
        }
      }
    }

    // 如果 leastMsg 為空或 index 不在範圍內，返回一個空的小部件或其他適當的處理方式
    return const SizedBox(); // 添加了明確的返回語句
  }
}

// ignore: must_be_immutable
class MessageItemTitle extends StatelessWidget {
  MessageItemTitle({Key? key, required this.messageData, required this.ourUid}) : super(key: key);
  final String ourUid;

  final MessageData messageData;
  SafeMsgStore safeMsgStore = SafeMsgStore();
  SafeUtilStore safeUtilStore = SafeUtilStore();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // await safeUtilStore.writeIsSend(messageData.remoteUid,true);
        Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatRoomPage(ourUid:ourUid, friendsUid: messageData.remoteUid,)));
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
