// login_form.dart
// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_login_btn_pressed.dart';

// define a widget class for login form
class LoginForm extends StatefulWidget {
  // constructor with a callback function as parameter
  const LoginForm(this.updateHintMsg, {super.key});

  // define the callback function as a field
  final Function updateHintMsg;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  // define the controller as fields
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
              widget
                  .updateHintMsg), // use widget to access the callback function
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('登入'),
        ),
      ],
    );
  }
}
