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
  String _requestFriendsType = 'username'; // 預設按鈕為'username'
  String ourName = '';

  @override
  void initState() {
    super.initState();
    _requestFriendsController = TextEditingController();
    // 將_requestFriendsType設置為 'username'
    _requestFriendsType = 'username';
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
        final resBody = jsonDecode(res.body);
        // print('[friends_add_page] 好友邀請送出型態: $_requestFriendsType');
        // print('[friends_add_page] 好友邀請狀態碼: $statusCode');
        if (mounted) {
          if (statusCode == 200) {
            loginErrorMsg(context, 'Friend request sent successfully.');
          } else if (statusCode == 403) {
            loginErrorMsg(context, 'Sender of friend request does not exist');
          } else if (statusCode == 409) {
            if (resBody['message'] == '已為好友，無需傳送好友邀請') {
              loginErrorMsg(
                  context, 'Already friends, no need to send friend request.');
            } else if (resBody['message'] == '您不能傳送好友邀請給自己') {
              loginErrorMsg(
                  context, 'You cannot send friend request to yourself.');
            } else if (resBody['message'] == '已傳送過好友邀請，請等待對方回覆') {
              loginErrorMsg(context,
                  'Friend request already sent. Please wait for their response.');
            }
          } else {
            loginErrorMsg(context,
                'Server encountered an error. \n Please make sure to select a submission type');
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
          future: getOurName(), // 等待獲取名字
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 若異步未完成，則需等待
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              
              String ourName = snapshot.data ?? ''; // get the name
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
                        'Your Username: $ourName',
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
                                    ? const Color.fromARGB(255, 255, 136, 67)
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
                            fixedSize: const Size(150, 50), 
                            backgroundColor: const Color.fromARGB(
                                255, 255, 136, 67),
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
              return Text('Error: ${snapshot.error}');
            }
          },
        ),
      ),
    );
  }
}
