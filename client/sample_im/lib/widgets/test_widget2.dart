// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_test_btn2_pressed.dart';

class TestWidget2 extends StatefulWidget {
  const TestWidget2(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  TestWidget2State createState() => TestWidget2State();
}

class TestWidget2State extends State<TestWidget2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async => await onTestBtnPressed2(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('萬用測試鈕2'),
        ),
      ],
    );
  }
}
