// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'signal_protocol.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // 確保Flutter初始化
  // await SharedPreferences.getInstance(); // 等待SharedPreferences實例化
  runApp(const MyMsgWidget());
}

class MyMsgWidget extends StatefulWidget {
  const MyMsgWidget({super.key});

  @override
  State<MyMsgWidget> createState() => _MyMsgWidgetState();
}

class _MyMsgWidgetState extends State<MyMsgWidget> {
  TextEditingController idController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController spKeyController = TextEditingController();
  TextEditingController spValueController = TextEditingController();
  TextEditingController safePreKeyStoreController = TextEditingController();
  TextEditingController safePreKeyStoreController2 = TextEditingController();

  String msgContent = "這是內容";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Omelet.im test"),
        ),
        body: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(hintText: "輸入發送對象的id"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: "輸入要傳送的訊息"),
            ),
            TextField(
              controller: spKeyController,
              decoration: const InputDecoration(hintText: "輸入要儲存/讀取的key"),
            ),
            TextField(
              controller: spValueController,
              decoration: const InputDecoration(hintText: "輸入要儲存的value"),
            ),
            // const TextField(decoration: InputDecoration(hintText: "輸入訊息")),
            Text(msgContent, textDirection: TextDirection.ltr),
            ElevatedButton(
              onPressed: onSendMsgBtnPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("發送訊息"),
            ),
            ElevatedButton(
              onPressed: () async => await onWriteBtnPressed(
                  spKeyController.text, spValueController.text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("寫入內容"),
            ),
            ElevatedButton(
              onPressed: () async =>
                  await onRemoveBtnPressed(spKeyController.text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              child: const Text("移除內容"),
            ),
            ElevatedButton(
              onPressed: () async => await onRemoveAllBtnPressed(),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("移除所有內容"),
            ),
            ElevatedButton(
              onPressed: () async =>
                  await onReadBtnPressed(spKeyController.text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text("讀取內容"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: safePreKeyStoreController,
              decoration: const InputDecoration(hintText: "輸入 preKey id"),
            ),
            TextField(
              controller: safePreKeyStoreController2,
              decoration: const InputDecoration(hintText: "輸入 preKey record"),
            ),
            ElevatedButton(
              onPressed: () async => await onWriteJsonBtnPressed(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text("寫入json內容"),
            ),
            ElevatedButton(
              onPressed: () async => await onGenerateKeyBtnPressed(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("生成並儲存金鑰"),
            ),
            ElevatedButton(
              onPressed: () async =>
                  await onLoadPreKeyBtnPressed(safePreKeyStoreController.text),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 116, 167, 209)),
              child: const Text("loadPreKey()"),
            ),
            ElevatedButton(
              onPressed: () async => await onContainsPreKeyBtnPressed(
                  safePreKeyStoreController.text),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 116, 167, 209)),
              child: const Text("containsPreKey()"),
            ),
            ElevatedButton(
              onPressed: () async => await onRemovePreKeyBtnPressed(
                  safePreKeyStoreController.text),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 116, 167, 209)),
              child: const Text("removePreKey()"),
            ),
            ElevatedButton(
              onPressed: () async => await onStorePreKeyBtnPressed(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 116, 167, 209)),
              child: const Text("storePreKey()"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async => await onStoreJWTBtnPressed(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 142, 116, 209)),
              child: const Text("儲存jwt(模擬登入功能)"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSendMsgBtnPressed() async {
    io.Socket socket = io.io('http://localhost:3000',
        io.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) async {
      final storage = new FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      print(token);
      socket.emit('clientReturnJwtToServer', token);
      print('backend connected');
    });

    // socket.emit('sendMsgToBackend', {
    //   'token': 'q1a2s3d4f5g6',
    //   'receiverID': idController.text,
    //   'msg': contentController.text
    // });

    // socket.on('event', (data) => print(data));
    // socket.onDisconnect((_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));

    socket.on('sendMsgToClient', (content) => {print('client已接收 $content')});

    setState(() {
      msgContent =
          "接收者 id: ${idController.text}\n發送內容： ${contentController.text}"; // 更新msgContent的值為"hello"
    });
  }
}
// ref: https://youtu.be/n8eY4qb7Dgw
