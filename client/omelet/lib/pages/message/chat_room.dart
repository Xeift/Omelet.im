import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/componets/message/glow_bar.dart';
import 'package:omelet/theme/theme_constants.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omelet/utils/load_local_info.dart';

import 'package:omelet/api/post/login_api.dart';


import '../../models/message_data.dart';


class ChatRoomPage extends StatelessWidget {

  static Route route(MessageData data) => MaterialPageRoute(
    builder:(context) => ChatRoomPage(
      messageData: data,
    )
  );



  const ChatRoomPage({Key? key, required this.messageData}) : super(key: key);
  

 final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading:
        IconButton(icon: const Icon(Icons.arrow_back_ios),onPressed:(){
           Navigator.of(context).pop();
        }),
        elevation: 0.0,
        backgroundColor:const Color.fromARGB(255, 0, 0, 0).withAlpha(30),
        title: AppBarTitle(
          messageData: messageData,
        ),
      ),
      body:const Column(
        children:[
          Expanded(child: DemoMessageList()
          ),
          _ActionBar(),
          
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

List<Map<String, dynamic>> msgs = [
  {
    'timestamp': 1709969515576,
    'type': 'text',
    'receiver': 551338674692820992,
    'sender': 552415467919118336,
    'content': '早安'
  },
  {
    'timestamp': 1709969440757,
    'type': 'text',
    'sender': 551338674692820992,
    'receiver': 552415467919118336,
    'content': '你也早'
  },
  {
    'timestamp': 1709969440758,
    'type': 'text',
    'receiver': 552415467919118336,
    'sender': 551338674692820992,
    'content': '今天天氣如何？'
  },
  {
    'timestamp': 1709969440759,
    'type': 'text',
    'sender': 552415467919118336,
    'receiver': 551338674692820992,
    'content': '天氣很好'
  },
  {
    'timestamp': 1709969440760,
    'type': 'text',
    'receiver': 552415467919118336,
    'sender': 551338674692820992,
    'content': '那我們去公園吧'
  },
  {
    'timestamp': 1709969440761,
    'type': 'text',
    'sender': 552415467919118336,
    'receiver': 551338674692820992,
    'content': '好的，我們見面的地點在哪裡？'
  },
  {
    'timestamp': 1709969440762,
    'type': 'text',
    'receiver': 552415467919118336,
    'sender': 551338674692820992,
    'content': '在公園的入口處見面'
  },
  {
    'timestamp': 1709969440763,
    'type': 'text',
    'sender': 552415467919118336,
    'receiver': 551338674692820992,
    'content': '好的，我會準時到達'
  },
];

class DemoMessageList extends StatelessWidget {
  const DemoMessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: loadUid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 如果仍在等待 UID，则显示加载指示器或其他加载状态
          return const CircularProgressIndicator(); // 例如，显示一个圆形进度指示器
        } else if (snapshot.hasError) {
          // 处理加载 UID 时出现的错误
          return Text('Error loading UID: ${snapshot.error}');
        } else {
          // 获取 UID
          String? uid = snapshot.data;

          // 构建消息列表
          return ListView.builder(
            itemCount: msgs.length,
            itemBuilder: (context, index) {
              final message = msgs[index];
              print('使用這id{$uid}');
              print(message['sender']);
              // 判断消息是否属于当前用户
              final isOwnMessage = message['sender'].toString() == uid;
              print(isOwnMessage);

              return isOwnMessage
                  ? MessageTitle(
                      message: message['content'],
                      messageDate: DateFormat('h:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(message['timestamp']),
                      ),
                    )
                  : MessageOwnTitle(
                      message: message['content'],
                      messageDate: DateFormat('h:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(message['timestamp']),
                      ),
                    );
            },
          );
        }
      },
    );
  }
}


class MessageTitle extends StatelessWidget {
  const MessageTitle({Key? key, required this.message, required this.messageDate}) : super(key: key);

  final String message;
  final String messageDate;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Text(message),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                messageDate,
                style:const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )
              ),
            ), 
          ]
        ),
      )
    );
  }
}
 

class MessageOwnTitle extends StatelessWidget {
  const MessageOwnTitle({Key? key, required this.message, required this.messageDate}) : super(key: key);

  final String message;
  final String messageDate;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(message,
                    style: const TextStyle(
                      color: AppColors.textLigth,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                messageDate,
                style:const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )
              ),
            ), 
          ]
        ),
      )
    );
  }
}


class DateLable extends StatelessWidget {
  const DateLable({Key? key,required this.lable}) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          decoration: BoxDecoration(
            color:Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child:Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0 ,horizontal: 12),
            child:Text(
              lable,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:Colors.black54,
              )
            ))
        ),)
    );
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar({Key? key}) : super(key: key);

  @override
  _ActionBarState createState() => _ActionBarState();
}



class _ActionBarState extends State<_ActionBar> {

  late TextEditingController sendMsge;
  @override
   _ActionBarState() {
    sendMsge = TextEditingController();
  }
  @override
  void initState() {
    super.initState();
    sendMsge.addListener(_onTextChange);
  }

  Timer? _debounce;

   Future<void> _sendMessage() async {
    if (sendMsge.text.isNotEmpty) {
    //   Future<void> onReadAllStorageBtnPressed(Function updateHintMsg) async {
    //     const storage = FlutterSecureStorage();
    //     final key = (await storage.readAll()).keys.toString();
    //     final allData = (await storage.readAll()).toString();
    //     await updateHintMsg('key👉$key\nallData👉$allData');
    //     print('key👉$key\nallData👉$allData');
    //     print(sendMsge.text);
    // }
    // onReadAllStorageBtnPressed(updateHintMsg);
      sendMsge.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _onTextChange() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (mounted) {
       // StreamChannel.of(context).channel.keyStroke();
      }
    });
  }

  @override
  void dispose() {
    sendMsge.removeListener(_onTextChange);
    sendMsge.dispose();

    super.dispose();
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
                  sendMsge.text = val;
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
              color:Color.fromARGB(255, 0, 0, 0),
              icon: Icons.send_rounded,
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}