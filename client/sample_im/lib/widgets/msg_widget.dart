// required lib
import 'package:flutter/material.dart';

// btn
import '../onBtnPressed/on_send_msg_btn_pressed.dart';

class MsgWidget extends StatefulWidget {
  const MsgWidget(this.updateHintMsg, {super.key});
  final Function updateHintMsg;

  @override
  MsgWidgetState createState() => MsgWidgetState();
}

class MsgWidgetState extends State<MsgWidget> {
  final TextEditingController serverUriController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController msgContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: serverUriController,
          decoration: const InputDecoration(hintText: '輸入後端伺服器 URI'),
        ),
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
              serverUriController.text,
              receiverController.text,
              msgContentController.text,
              widget.updateHintMsg),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
          child: const Text('發送訊息'),
        ),
      ],
    );
  }
}
