import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/componets/message/glow_bar.dart';
import 'package:omelet/theme/theme_constants.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';


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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageData.senderName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ),
      ],
    );
  }
}


class DemoMessageList extends StatelessWidget {
  const DemoMessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:const [
        DateLable(lable:'Yesterday'),
        MessageTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageOwnTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageOwnTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageOwnTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
        MessageOwnTitle(
          message:'Hi, Lucy',
          messageDate:'12:01 PM',
        ),
      ],
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
  final StreamMessageInputController controller =
      StreamMessageInputController();
    late final TextEditingController textEditingController;

  Timer? _debounce;

  Future<void> _sendMessage() async {
    if (controller.text.isNotEmpty) {
      StreamChannel.of(context).channel.sendMessage(controller.message);
      controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _onTextChange() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        StreamChannel.of(context).channel.keyStroke();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChange);
    controller.dispose();

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
                  controller.text = val;
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
              right: 24,
            ),
            child: GlowingActionButton(
              color:const Color.fromARGB(255, 106, 137, 158),
              icon: Icons.send_rounded,
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}