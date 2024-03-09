import 'package:flutter/material.dart';

import 'package:test_im_v4/on_btn_pressed/on_test_btn_pressed.dart';

class TestBtn extends StatefulWidget {
  const TestBtn(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  TestBtnState createState() => TestBtnState();
}

class TestBtnState extends State<TestBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async => await onTestBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('萬用測試鈕'),
        ),
      ],
    );
  }
}
