// ignore_for_file: avoid_print

// required lib
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
// import 'dart:convert';

// widget
import 'widgets/login_widget.dart';
import 'widgets/reset_widget.dart';
import 'widgets/readall_widget.dart';
import 'widgets/msg_widget.dart';

late io.Socket socket;
final hintMsgKey = GlobalKey();

void main() async {
  runApp(const MyMsgWidget());
}

class MyMsgWidget extends StatefulWidget {
  const MyMsgWidget({super.key});

  @override
  State<MyMsgWidget> createState() => _MyMsgWidgetState();
}

class _MyMsgWidgetState extends State<MyMsgWidget> {
  String hintMsg = '這是測試訊息UwU';

  @override
  void initState() {
    super.initState();
    initSocket(); // 啟動 App 時直接連線到 Socket.io Server
    // TODO:  檢查本地是否有 JWT
  }

  Future<void> initSocket() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50), // keep top space
            LoginWidget(updateHintMsg, catHintMsg), // login widget
            RemoveAllWidget(updateHintMsg), // remove all widget
            ReadAllWidget(updateHintMsg), // test widget
            MsgWidget(updateHintMsg), // remove all widget
            Text(
              hintMsg,
              textDirection: TextDirection.ltr,
              key: hintMsgKey,
            ), // display hint message
          ],
        ),
      )),
    );
  }

  void updateHintMsg(String newHintMsg) {
    setState(() {
      hintMsg = newHintMsg;
    });
  }

  void catHintMsg(String newHintMsg) {
    setState(() {
      hintMsg = '$hintMsg\n$newHintMsg';
    });
  }
}
