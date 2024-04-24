import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';

import 'package:omelet/api/post/send_friend_request_api.dart';
import 'package:omelet/componets/alert/alert_msg.dart';



class FriendsAddPage extends StatefulWidget {
  const FriendsAddPage({Key? key, required this.ourUid}) : super(key: key);
  final String ourUid;

  @override
  State<FriendsAddPage> createState() => _FriendsAddPageState();
}

class _FriendsAddPageState extends State<FriendsAddPage> {
  TextEditingController _requestFriendsController = TextEditingController();
  String _requestFriendsType = ''; // Store the type of friend request
  String ourName = '';

  @override
  void initState() {
    super.initState();
    _requestFriendsController = TextEditingController();
  }

  Future<String> getOurName() async {
    var res = await getUserPublicInfoApi(widget.ourUid);
    var resB = jsonDecode(res.body);
    ourName = resB['data']['username'];
    return ourName;
  }

  Future<void> _sendRequest() async {
    try {
      if (_requestFriendsController.text.trim().isNotEmpty &&
          _requestFriendsType.isNotEmpty) {
        final res = await sendFriendRequestApi(
            _requestFriendsController.text, _requestFriendsType);
        final statusCode = res.statusCode;
        final String resBody = res.body;
        print('[friends_add_page] 好友邀請送出型態: $_requestFriendsType');
        print('[friends_add_page] 好友邀請狀態碼: $statusCode');
        if (mounted) {
          if (statusCode == 200) {
            loginErrorMsg(context, 'Friend request sent successfully.');
          } else if (statusCode == 403) {
            loginErrorMsg(context, 'Sender of friend request does not exist');
          } else if (statusCode == 409) {
            loginErrorMsg(context, 'Already friends, no need to send friend request');
          } else {
            loginErrorMsg(context, 'Server encountered an error. \n Please make sure to select a submission type');
          }
        }

        print('[friends_add_page] 好友邀請回應: $resBody');

        setState(() {
          _requestFriendsController.clear();
        });
      }
    } catch (e) {
      print('Error sending friend request: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[friends_add_page]ourUid${widget.ourUid}');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: getOurName(), // 等待获取名字的异步操作
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 如果异步操作尚未完成，显示加载中的状态
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              // 如果异步操作已完成，获取到名字后构建 UI
              String ourName = snapshot.data ?? ''; // 获取到的名字
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Display user's name
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
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Your Username: $ourName', // 使用获取到的名字
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Friend request input section
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
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Button to select Uid
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _requestFriendsType = 'username';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _requestFriendsType ==
                                        'username'
                                    ? Color.fromARGB(255, 255, 136, 67)
                                    : Colors.white,
                              ),
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  color: _requestFriendsType == 'username'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            // Button to select Email
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _requestFriendsType = 'email';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _requestFriendsType == 'email'
                                    ? const Color.fromARGB(255, 255, 136, 67)
                                    : Colors.white,
                              ),
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: _requestFriendsType == 'email'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 20, left: 20),
                          child: TextField(
                            controller: _requestFriendsController,
                            decoration: InputDecoration(
                              hintText: _requestFriendsType == 'username'
                                  ? 'Add friend by Username'
                                  : 'Add friend by Email',
                            ),
                            onSubmitted: (_) => _sendRequest(),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Submit button
                        ElevatedButton(
                          onPressed: _sendRequest,
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(150, 50), // 设置按钮的固定尺寸
                            backgroundColor: Color.fromARGB(
                                255, 255, 136, 67), // 设置按钮的背景颜色
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // 如果发生错误，显示错误信息
              return Text('Error: ${snapshot.error}');
            }
          },
        ),
      ),
    );
  }
}
