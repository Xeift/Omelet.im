import 'package:flutter/material.dart';
import 'package:omelet/pages/chat_list_page.dart';

import '../../models/message_data.dart';
import '../../message/safe_msg_store.dart';

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
        //  
        leading:
        IconButton(icon: const Icon(Icons.arrow_back_ios),onPressed:(){
           Navigator.of(context).pop();
        }),
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0).withAlpha(30),
      ),
      body:Text('test'),
    );
  }
}