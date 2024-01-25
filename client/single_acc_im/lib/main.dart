// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'utils/server_uri.dart';
import 'utils/jwt.dart';
import 'utils/login.dart';
import 'signal_protocol/generate_and_store_key.dart';
import 'api/get/get_unread_msg_api.dart';
import 'message/safe_msg_store.dart';

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
    initSocket();
  }

  Future<void> initSocket() async {
    const storage = FlutterSecureStorage();

    // JWT 存在，直接連線到 Socket.io Server
    if (await isJwtExsist()) {
      socket = io.io(
          serverUri, io.OptionBuilder().setTransports(['websocket']).build());

      socket.onConnect((_) async {
        // 回傳 JWT，驗證身份
        socket.emit(
            'clientReturnJwtToServer', await storage.read(key: 'token'));
        print('backend connected');
        final res = await getUnreadMsgAPI();
        final List<dynamic> unreadMsgs = jsonDecode(res.body)['data'];

        // 儲存未讀訊息
        print(unreadMsgs);
        if (unreadMsgs.isNotEmpty) {
          print('store🤣🤣😂😎🤩🤩🤗🙂');
          final safeMsgStore = SafeMsgStore();
          await safeMsgStore.sortAndstoreUnreadMsg(unreadMsgs);
        }
      });

      // 接收伺服器轉發的訊息
      socket.on('serverForwardMsgToClient', (msg) async {
        print('client已接收\n$msg');
        final safeMsgStore = SafeMsgStore();
        await safeMsgStore.storeReceivedMsg(msg);
      });

      socket.on('jwtExpired', (data) async {
        // 後端檢查 JWT 過期
        updateHintMsg('登入階段已過期！重新登入');
        // 跳轉至登入頁面
        await login('q', 'a', updateHintMsg, catHintMsg);
        socket.emit(
            'clientReturnJwtToServer', await storage.read(key: 'token'));
      });
    } else {
      print('jwt 不存在❌\n該使用者第一次開啟 App，應跳轉至登入頁面並產生公鑰包\n');
      await login('q', 'a', updateHintMsg, catHintMsg);
      await generateAndStoreKey();
      await initSocket();
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
            // LoginWidget(updateHintMsg, catHintMsg), // login widget
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
