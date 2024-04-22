import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _requestFriendsController = TextEditingController();
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
            loginErrorMsg(context, '好友邀請傳送成功');
          } else if (statusCode == 403) {
            loginErrorMsg(context, '傳送好友邀請者不存在');
          } else if (statusCode == 409) {
            loginErrorMsg(context, '已為好友，無需傳送好友邀請');
          } else {
            loginErrorMsg(context, '伺服器發生錯誤');
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Display user's UID
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
                  '您的Uid: ${widget.ourUid}',
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
                            _requestFriendsType = 'uid';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _requestFriendsType == 'uid'
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(
                          'Uid',
                          style: TextStyle(
                            color: _requestFriendsType == 'uid'
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
                              ? Colors.black
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _requestFriendsController,
                      decoration: InputDecoration(
                        hintText: _requestFriendsType == 'uid'
                            ? '以Uid添加好友'
                            : '以Email添加好友',
                      ),
                      onSubmitted: (_) => _sendRequest(),
                    ),
                  ),
                  // Submit button
                  ElevatedButton(
                    onPressed: _sendRequest,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text('Submit'),
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
