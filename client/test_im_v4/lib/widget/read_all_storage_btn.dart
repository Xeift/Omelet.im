import 'package:flutter/material.dart';
import 'package:test_im_v4/on_btn_pressed/on_read_all_storage_btn_pressed.dart';

class ReadAllStorageBtn extends StatefulWidget {
  const ReadAllStorageBtn(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  ReadAllStorageBtnState createState() => ReadAllStorageBtnState();
}

class ReadAllStorageBtnState extends State<ReadAllStorageBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async =>
              await onReadAllStorageBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text('讀取所有儲存內容'),
        ),
      ],
    );
  }
}
