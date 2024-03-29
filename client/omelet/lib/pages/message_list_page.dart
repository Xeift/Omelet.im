import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/storage/safe_util_store.dart';
// import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../models/message_data.dart';
import 'package:omelet/utils/helpers.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  SafeUtilStore safeUtilStore = SafeUtilStore();
  SafeMsgStore safeMsgStore = SafeMsgStore();
  List<Map<String, dynamic>> isSended = [];
  @override
  void initState() {
    super.initState();
    _loadIsSendedList();
  }

  Future<void> _loadIsSendedList() async {
    List<Map<String, dynamic>> loadIsSendList = await safeUtilStore.readIsSendeList();
    List<Map<String, dynamic>> userInfo=[];
    List<Map<String,dynamic>> leastMsg = [];
    //TODO:須將isSended判斷後抓取資料
    if(loadIsSendList.isNotEmpty){
      print('[message_list_page.dart]$loadIsSendList');
      for (var element in loadIsSendList) {
      if (element['isSended'] == true) {
        var res = await getUserPublicInfoApi(element['uid']);
        Map<String, dynamic> jsonResBody = jsonDecode(res.body); 
        var resM = await safeMsgStore.getChatList();
        
        print('[message_list_page.dart]resM$resM');
        print('[message_list_page.dart]$jsonResBody');
        
      }
    }
    }else{
      print('[message_list_page.dart]布林列表為空');
    }
    setState(() {
      isSended = loadIsSendList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100, // 您希望顯示的消息數量
      itemBuilder: (context, index) {
        return _delegate(context, index);
      },
    );
  }

  Widget _delegate(BuildContext context, int index) {
    final date = Helpers.randomDate();
    return MessageItemTitle(
      messageData: MessageData(
        senderName: 'TestUser',
        message: 'HIHI',
        remoteUid: '552415467919118336', // 請確定您有合適的 remoteUid
        messageDate: date,
        profilePicture: Helpers.randomPictureUrl(),
      ),
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
        // Navigator.of(context).push(ChatRoomPage.route(messageData,'552415467919118336'));
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
