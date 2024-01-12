// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_login_btn_pressed.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget(this.updateHintMsg, this.catHintMsg, {super.key});
  final Function updateHintMsg;
  final Function catHintMsg;

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final TextEditingController serverUriController = TextEditingController();
  final TextEditingController accController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: serverUriController,
          decoration: const InputDecoration(hintText: '輸入後端伺服器 URI'),
        ),
        TextField(
          controller: accController,
          decoration: const InputDecoration(hintText: '輸入帳號'),
        ),
        TextField(
          controller: pwdController,
          decoration: const InputDecoration(hintText: '輸入密碼'),
        ),
        ElevatedButton(
          onPressed: () async => await onLoginBtnPressed(
              serverUriController.text,
              accController.text,
              pwdController.text,
              widget.updateHintMsg,
              widget.catHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('登入'),
        ),
      ],
    );
  }
}
