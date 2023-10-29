// required lib
import 'package:flutter/material.dart';

// btn
import 'onBtnPressed/on_login_btn_pressed.dart';

void main() async {
  runApp(const MyMsgWidget());
}

class MyMsgWidget extends StatefulWidget {
  const MyMsgWidget({super.key});

  @override
  State<MyMsgWidget> createState() => _MyMsgWidgetState();
}

class _MyMsgWidgetState extends State<MyMsgWidget> {
  TextEditingController serverUriController = TextEditingController();
  TextEditingController accController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50), // keep top space
            TextField(
              controller: serverUriController,
              decoration: const InputDecoration(hintText: '輸入後端伺服器 URI'),
            ),
            TextField(
              controller: accController,
              decoration: const InputDecoration(hintText: '輸入帳號'),
            ),
            TextField(
              controller: accController,
              decoration: const InputDecoration(hintText: '輸入密碼'),
            ),
            ElevatedButton(
              onPressed: () async => await onLoginBtnPressed(
                  serverUriController.text,
                  accController.text,
                  pwdController.text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('登入'),
            ),
          ],
        ),
      )),
    );
  }
}
