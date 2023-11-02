// required lib
// ignore_for_file: avoid_print

import 'package:socket_io_client/socket_io_client.dart' as io;
import './../debug_utils/debug_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './store/safe_msg_store.dart';
import 'package:flutter/material.dart';

import 'widgets/login_widget.dart';
import 'widgets/reset_widget.dart';
import 'widgets/msg_widget.dart';

late io.Socket socket;

void main() async {
  runApp(const MyMsgWidget());
  final serverUri = (await readDebugConfig())['serverUri'];
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  socket =
      io.io(serverUri, io.OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) async {
    socket.emit('clientReturnJwtToServer', token);
    print('backend connected');

    // receive msg
    socket.on('serverForwardMsgToClient', (msg) {
      print('client已接收 $msg');
      // updateHintMsg('client已接收 $msg');

      // store received msg
      final safeMsgStore = SafeMsgStore();
      safeMsgStore.writeMsg(msg['sender'], msg);
    });
  });
}

class MyMsgWidget extends StatefulWidget {
  const MyMsgWidget({super.key});

  @override
  State<MyMsgWidget> createState() => _MyMsgWidgetState();
}

class _MyMsgWidgetState extends State<MyMsgWidget> {
  String hintMsg = '未登入';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50), // keep top space
            LoginWidget(updateHintMsg), // login widget
            RemoveAllWidget(updateHintMsg), // remove all widget
            MsgWidget(updateHintMsg), // remove all widget
            Text(hintMsg,
                textDirection: TextDirection.ltr), // display hint message
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
}
