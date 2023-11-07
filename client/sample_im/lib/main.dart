// required lib
// ignore_for_file: avoid_print

import 'package:socket_io_client/socket_io_client.dart' as io;
import './../debug_utils/debug_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './store/safe_msg_store.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'widgets/login_widget.dart';
import 'widgets/reset_widget.dart';
import 'widgets/msg_widget.dart';

import './utils/get_unread_msg_api.dart';

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
  String hintMsg = '未登入';

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    final serverUri = (await readDebugConfig())['serverUri'];
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (serverUri != null) {
      // ----------------------------------------------------------------
      socket = io.io(
          serverUri, io.OptionBuilder().setTransports(['websocket']).build());

      socket.onConnect((_) async {
        socket.emit('clientReturnJwtToServer', token);
        print('backend connected');

        final res = await getUnreadMsgAPI(serverUri);
        final unreadMsgs = jsonDecode(res.body)['data'];

        // store unread msg
        for (var unreadMsg in unreadMsgs) {
          final safeMsgStore = SafeMsgStore();
          print(unreadMsg);
          await safeMsgStore.writeMsg(unreadMsg['sender'], {
            'timestamp': unreadMsg['timestamp'],
            'type': unreadMsg['type'],
            'receiver': 'self',
            'sender': unreadMsg['sender'],
            'content': unreadMsg['content']
          });
        }

        final safeMsgStore = SafeMsgStore();
        final historyMsgs = await safeMsgStore.readAllMsg('491437500754038784');
        // 491437500754038784 x
        // 492312533160431617 a11
        for (var historyMsg in historyMsgs) {
          final decodedHistoryMsg = jsonDecode(historyMsg);
          catHintMsg(
              '${decodedHistoryMsg['sender']}: ${decodedHistoryMsg['content']}');
        }

        // receive msg
        socket.on('serverForwardMsgToClient', (msg) {
          print('test client已接收 $msg');

          catHintMsg('${msg['sender']}: ${msg['content']}');

          // store received msg
          final safeMsgStore = SafeMsgStore();
          safeMsgStore.writeMsg(msg['sender'], msg);
        });
      });
      // ----------------------------------------------------------------
    }
  }

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
