// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_readall_btn_pressed.dart';

class ReadAllWidget extends StatefulWidget {
  const ReadAllWidget(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  ReadAllWidgetState createState() => ReadAllWidgetState();
}

class ReadAllWidgetState extends State<ReadAllWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async => await onTestBtnPressed2(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('讀取所有儲存內容'),
        ),
      ],
    );
  }
}
