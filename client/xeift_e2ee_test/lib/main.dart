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
  TextEditingController accController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController apiBaseUrlController = TextEditingController();

  String msgContent = "這是內容";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // appBar: AppBar(
          //   title: const Text("Omelet.im test"),
          // ),
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
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
            TextField(
              controller: idController,
              decoration: const InputDecoration(hintText: "輸入發送對象的id"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: "輸入要傳送的訊息"),
            ),
            TextField(
              controller: apiBaseUrlController,
              decoration: const InputDecoration(hintText: "輸入後端伺服器 Base URL"),
            ),
            ElevatedButton(
              onPressed: onSendMsgBtnPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("發送訊息"),
            ),

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
            TextField(
              controller: accController,
              decoration: const InputDecoration(hintText: "輸入帳號"),
            ),
            TextField(
              controller: pwdController,
              decoration: const InputDecoration(hintText: "輸入密碼"),
            ),
            ElevatedButton(
              onPressed: () async => await onStoreJWTBtnPressed(
                  apiBaseUrlController.text,
                  accController.text,
                  pwdController.text),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 142, 116, 209)),
              child: const Text("登入並儲存jwt)"),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> onReadBtnPressed(String key) async {
    print('read');
    print(key);
    const storage = FlutterSecureStorage();
    String value = (await storage.read(key: key)).toString();
    print('$key 內容: $value 內容形態: ${value.runtimeType}');
    setState(() {
      msgContent = value; // 更新msgContent的值為"hello"
    });
  }

  Future<void> onSendMsgBtnPressed() async {
    String apiBaseUrl = apiBaseUrlController.text;

    io.Socket socket = io.io(
        apiBaseUrl, io.OptionBuilder().setTransports(['websocket']).build());

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    socket.onConnect((_) async {
      print(token);
      socket.emit('clientReturnJwtToServer', token);
      print('backend connected');
    });

    socket.emit('clientSendMsgToServer', {
      'token': token,
      'receiverUid': idController.text,
      'msg': contentController.text
    });

    socket.onDisconnect((_) => print('disconnect'));

    socket.on('serverForwardMsgToClient', (content) {
      print('client已接收 $content');
      setState(() {
        msgContent = "client已接收 $content";
      });
    });

    setState(() {
      msgContent =
          "接收者 id: ${idController.text}\n發送內容： ${contentController.text}"; // 更新msgContent的值為"hello"
    });
  }
}
// ref: https://youtu.be/n8eY4qb7Dgw
