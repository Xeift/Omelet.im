// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_test_btn_pressed.dart';

class TestWidget extends StatefulWidget {
  const TestWidget(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async => await onTestBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('萬用測試鈕'),
        ),
      ],
    );
  }
}
