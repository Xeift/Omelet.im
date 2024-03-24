import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/post/send_friend_request_api.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/theme/theme_constants.dart';

class FriendsAddPage extends StatefulWidget {
  const FriendsAddPage({Key? key}) : super(key: key);

  @override
  State<FriendsAddPage> createState() => _FriendsAddPageState();
}

class _FriendsAddPageState extends State<FriendsAddPage> {
  TextEditingController _requestFriendsController = TextEditingController();
  bool _buttonSelectPressed = false;

  @override
  void initState() {
    super.initState();
    _requestFriendsController = TextEditingController();
  }
  late final String resT = _requestFriendsController.text;

  Future<void> _sendRequest() async{
    if(_requestFriendsController.text.trim().isNotEmpty){
      print('[friends_add_page]送出好友邀請{$resT}');
      final res = await sendFriendRequestApi(_requestFriendsController.text,'uid');
      final statusCode  = res.statusCode;
      print('[friends_add_page]好友邀請狀態碼{$statusCode}');
      setState(() {
        _requestFriendsController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 325,
              height: 85,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 10,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      offset: const Offset(-4.0, -4.0),
                      blurRadius: 10,
                      spreadRadius: 1.0,
                    ),
                  ]),
              child: Center(
                child: Text(
                  '您的Uid: $ourUid',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ), // 使用ourUid变量
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 325,
              height: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 10,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      offset: const Offset(-4.0, -4.0),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    ),
                  ]),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _buttonSelectPressed = true;
                          });
                          // 在这里执行按钮1按下时的操作
                          // 比如获取文本框中的内容 _textController.text
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _buttonSelectPressed
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(
                          'Uid',
                          style: TextStyle(
                            color: _buttonSelectPressed
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _buttonSelectPressed = false;
                          });
                          // 在这里执行按钮1按下时的操作
                          // 比如获取文本框中的内容 _textController.text
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _buttonSelectPressed
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 0, 0, 0),
                        ),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: _buttonSelectPressed
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _requestFriendsController,
                      decoration: InputDecoration(
                        hintText:
                            _buttonSelectPressed ? '以Uid添加好友' : '以Email添加好友',
                      ),
                      onSubmitted: (_) => _sendRequest(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      _sendRequest();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
