import 'package:flutter/material.dart';

import 'package:test_im_v4/widget/read_all_storage_btn.dart';
import 'package:test_im_v4/widget/remove_all_storage_btn.dart';
import 'package:test_im_v4/widget/msg_widget.dart';
import 'package:test_im_v4/widget/test_btn.dart';

import 'package:test_im_v4/utils/init_socket.dart';

final hintMsgKey = GlobalKey();

void main() {
  runApp(const MainApp());
  initSocket();
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String hintMsg = '這是提示訊息UwU';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(height: 50),
          ReadAllStorageBtn(updateHintMsg),
          RemoveAllStorageBtn(updateHintMsg),
          MsgWidget(updateHintMsg),
          TestBtn(updateHintMsg),
          Text(
            hintMsg,
            textDirection: TextDirection.ltr,
            key: hintMsgKey,
          ),
        ])),
      ),
    );
  }

  void updateHintMsg(String newHintMsg) {
    setState(() {
      hintMsg = newHintMsg;
    });
  }
}
