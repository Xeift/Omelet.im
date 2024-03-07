import 'package:flutter/material.dart';

import 'package:test_im_v4/on_btn_pressed/on_send_msg_btn_pressed.dart';
import 'package:test_im_v4/on_btn_pressed/on_update_pfp_btn_pressed.dart';
import 'package:test_im_v4/on_btn_pressed/on_select_image_btn_pressed.dart';
import 'package:test_im_v4/on_btn_pressed/on_read_chat_list_btn_pressed.dart';

class MsgWidget extends StatefulWidget {
  const MsgWidget(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  MsgWidgetState createState() => MsgWidgetState();
}

class MsgWidgetState extends State<MsgWidget> {
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController msgContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: receiverController,
          decoration: const InputDecoration(hintText: '輸入接收者 id'),
        ),
        TextField(
          controller: msgContentController,
          decoration: const InputDecoration(hintText: '輸入發送內容'),
        ),
        ElevatedButton(
          onPressed: () async => await onSendMsgBtnPressed(
              receiverController.text,
              msgContentController.text,
              widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
          child: const Text('發送訊息'),
        ),
        ElevatedButton(
          onPressed: () async =>
              await onGetUserListBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: const Text('取得使用者列表'),
        ),
        ElevatedButton(
          onPressed: () async =>
              await onUpdatePfpBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: const Text('更新頭像'),
        ),
        ElevatedButton(
          onPressed: () async =>
              await onSelectImageBtnPressed(widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: const Text('選擇圖片 準備傳送圖片'),
        ),
      ],
    );
  }
}
