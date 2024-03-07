import 'package:flutter/material.dart';

import 'package:test_im_v4/on_btn_pressed/on_remove_all_storage_btn_pressed.dart';

class RemoveAllStorageBtn extends StatefulWidget {
  const RemoveAllStorageBtn(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  RemoveAllStorageBtnState createState() => RemoveAllStorageBtnState();
}

class RemoveAllStorageBtnState extends State<RemoveAllStorageBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async =>
              await onRemoveAllBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('清除全部儲存空間內容'),
        ),
      ],
    );
  }
}
