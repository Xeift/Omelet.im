// required lib
import 'package:flutter/material.dart';

// login form
import 'widgets/login_form.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50), // keep top space
            LoginForm(updateHintMsg), // login widget
            Text(hintMsg, textDirection: TextDirection.ltr),
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
