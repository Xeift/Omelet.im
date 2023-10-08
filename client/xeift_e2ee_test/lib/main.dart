// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
// import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'signal_protocol_1.dart';

void main() {
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
            // const TextField(decoration: InputDecoration(hintText: "輸入訊息")),
            Text(msgContent, textDirection: TextDirection.ltr),
            ElevatedButton(
              onPressed: onBtnPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("發送訊息"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onBtnPressed() async {
    await install();
    io.Socket socket = io.io('http://localhost:3000',
        io.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) {
      print('connected');
    });
    socket.emit('helloFromDartClient', contentController.text);
    // socket.on('event', (data) => print(data));
    // socket.onDisconnect((_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));

    print('-------------\n');
    print(idController.text);
    print(contentController.text);
    print('-------------\n');
    setState(() {
      msgContent =
          "接收者 id: ${idController.text}\n發送內容： ${contentController.text}"; // 更新msgContent的值為"hello"
    });
  }
}
// ref: https://youtu.be/n8eY4qb7Dgw







