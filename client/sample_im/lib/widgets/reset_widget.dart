// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_remove_all_btn_pressed.dart';

class RemoveAllWidget extends StatefulWidget {
  const RemoveAllWidget(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  RemoveAllWidgetState createState() => RemoveAllWidgetState();
}

class RemoveAllWidgetState extends State<RemoveAllWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async =>
              await onRemoveAllBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('全部重置 - Debug 用'),
        ),
      ],
    );
  }
}
