import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/post/get_translated_sentence_api.dart';
import 'package:omelet/componets/button/on_select_image_btn_pressed.dart';
import 'package:omelet/componets/button/on_send_msg_btn_pressed.dart';
import 'package:omelet/componets/message/glow_bar.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/storage/safe_config_store.dart';
import 'package:omelet/storage/safe_msg_store.dart';

class MultiChatRoomPage extends StatefulWidget {
  const MultiChatRoomPage(
      {super.key,
      required this.friends_uidA,
      required this.friends_uidB,
      required this.ourUid});
  final String friends_uidA;
  final String friends_uidB;
  final String ourUid;
  
  @override
  State<MultiChatRoomPage> createState() => MultiChatRoomPageState();
}

class MultiChatRoomPageState extends State<MultiChatRoomPage> {
  static GlobalKey updateMultiChatKey = GlobalKey();
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  late Map<String, dynamic> friendsAInfo;
  late Map<String, dynamic> friendsBInfo;
  bool isChangeWindow = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // 在初始化时获取好友数据
    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeData() async {
    try {
      // 使用 Future.wait 等待两个异步操作完成
      await Future.wait([
        _fetchUserInfo(widget.friends_uidA),
        _fetchUserInfo(widget.friends_uidB),
      ]).then((List<Map<String, dynamic>> results) {
        // results 是一个包含两个 Map 的列表，分别是 friendsAInfo 和 friendsBInfo
        setState(() {
          friendsAInfo = results[0];
          friendsBInfo = results[1];
          isLoading = false; // 加载完成后将 isLoading 设置为 false
        });
      });
    } catch (e) {
      print('Error initializing data: $e');
      setState(() {
        isLoading = false; // 如果发生错误，也要将 isLoading 设置为 false
      });
    }
  }

  static currenInstanceInMultiChat() {
    var state = MultiChatRoomPageState.updateMultiChatKey.currentContext
        ?.findAncestorStateOfType();
    return state;
  }
  

  Future<Map<String, dynamic>> _fetchUserInfo(String userUid) async {
    try {
      final response = await getUserPublicInfoApi(userUid);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseData['data']['uid'] = userUid;
        return responseData;
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return {};
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // 加载完成后显示整个页面
      return Scaffold(
        appBar: AppBar(
          title: Text('Multi_windows'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isChangeWindow = !isChangeWindow;
                });
                print('[multi_chat_room.dart]isChangeWindow:$isChangeWindow');
              },
              child: Icon(Icons.account_tree_rounded),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _ReadMessageList(
                friendsInfo: isChangeWindow ? friendsAInfo : friendsBInfo,
                isTranslate: false,
                ourUid: widget.ourUid,
              ),
            ),

            Container(
              height: 2,
              color: Colors.amber,
            ),

            Expanded(
              child: _ReadMessageList(
                friendsInfo: isChangeWindow ? friendsBInfo : friendsAInfo,
                isTranslate: false,
                ourUid: widget.ourUid,
              ),
            ),
            Divider(height: 1.0),
            _ActionBarForMulti(
              friendsInfo: isChangeWindow ? friendsBInfo : friendsAInfo,
              isTranslate: false,
            ),
          ],
        ),
      );
    }
    
  }
 reloadDataInMulti() async{
    setState(() {
      print('update whol page');
    _ReadMessageList;
    });
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
  }) : super(key: key);
  final String text = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text('User')),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'User',
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//==============讀取訊息=====================

class _ReadMessageList extends StatelessWidget {
  final SafeMsgStore safeMsgStore = SafeMsgStore();

  _ReadMessageList(
      {super.key,
      required this.friendsInfo,
      required this.isTranslate,
      required this.ourUid});
  final Map<String, dynamic> friendsInfo;
  final bool isTranslate;
  final String ourUid;
  Future<List<Map<String, dynamic>>> fetchAndDisplayMessages() async {
    print('test:${friendsInfo['data']['uid']}');
    List<String> messages =
        await safeMsgStore.readAllMsg(friendsInfo['data']['uid']);
    if (messages.isNotEmpty) {
      List<Map<String, dynamic>> parsedMessages = messages
          .map((message) => jsonDecode(message))
          .toList()
          .cast<Map<String, dynamic>>();
      print('[chat_room_page] 抓取內存訊息：$parsedMessages');
      return parsedMessages;
    } else {
      print('[chat_room_page] 沒有訊息資料');
      return []; // 添加一個默認返回值，例如空列表
    }
  }

  @override
  Widget build(BuildContext context) {
    print('加載訊息中....');
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchAndDisplayMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('無訊息'),
          );
        }
        List<Map<String, dynamic>> realMsg = snapshot.data!;

        // 按時間先後順序對訊息進行排序
        realMsg.sort((a, b) {
          int timestampA = int.parse(a['timestamp']);
          int timestampB = int.parse(b['timestamp']);
          return timestampB.compareTo(timestampA);
        });

        return ListView.builder(
          reverse: true,
          itemCount: realMsg.length,
          itemBuilder: (context, index) {
            final realmessage = realMsg[index];
            int timestamp = int.parse(realmessage['timestamp']);
            final bool isOwnMessage =
                realmessage['sender'].toString() == ourUid; //訊息數否為寄送者
            final isImage = realmessage['type'] != 'text';
            var imageDataInt = isImage //判斷訊息是否為圖片
                ? (realmessage['content'] as String)
                    .substring(1, realmessage['content'].length - 1)
                    .split(',')
                    .map((String byteString) => int.parse(byteString.trim()))
                    .toList()
                : null;

            print('[chat_room_page] 圖像資料：$imageDataInt');
            final imageData =
                isImage ? Uint8List.fromList(imageDataInt!) : null;

            return isTranslate //判斷翻譯功能
                ? (isOwnMessage //啟用情況下
                    ? (isImage
                        ? ImgOwnTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : MessageOwnTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          ))
                    : (isImage
                        ? ImgTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : AIMessageTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                            ourUid: ourUid,
                          )))
                : (isOwnMessage //非啟用情況
                    ? (isImage
                        ? ImgOwnTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : MessageOwnTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          ))
                    : (isImage
                        ? ImgTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : MessageTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          ))); // 如果不需要顯示消息，返回一個空的容器
          },
        );
      },
    );
  }
}

class _ActionBarForMulti extends StatefulWidget {
  const _ActionBarForMulti(
      {Key? key, required this.friendsInfo, required this.isTranslate})
      : super(key: key);
  final Map<String, dynamic> friendsInfo;
  final bool isTranslate;

  @override
  _ActionBarForMultiState createState() => _ActionBarForMultiState();
}

class _ActionBarForMultiState extends State<_ActionBarForMulti> {
  late TextEditingController _sendMsgController;
  final bool isSpecial = false;
  SafeConfigStore safeConfigStore = SafeConfigStore();

  @override
  void initState() {
    super.initState();
    _sendMsgController = TextEditingController();
  }

  Future<void> _sendMessage() async {
    if (_sendMsgController.text.trim().isNotEmpty) {
      onSendMsgBtnPressed(
          widget.friendsInfo['data']['uid'], _sendMsgController.text);
      setState(() {
        _sendMsgController.clear();
      });
    }
  }

  @override
  void dispose() {
    _sendMsgController.dispose();
    super.dispose();
  }

  void _changeTranslateStatus(bool isTranslateStatus) async {
    if (isTranslateStatus) {
      await safeConfigStore
          .enableTranslation(widget.friendsInfo['data']['uid']);
    } else {
      await safeConfigStore
          .disableTranslation(widget.friendsInfo['data']['uid']);
    }

    setState(() {
      ChatRoomPageState.currenInstance()?.reloadData();
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: true,
      top: false,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoPopupSurface(
                    child: Material(
                      child: SizedBox(
                        height: 130,
                        width: screenWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    print(
                                        '[chat_room_page.dart]uid:${widget.friendsInfo['data']['uid']}');
                                    onSelectImageBtnPressed(
                                        widget.friendsInfo['data']['uid']);
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  child: const SizedBox(
                                    child: Icon(
                                      CupertinoIcons.folder,
                                      size: 30,
                                      color: Color.fromARGB(255, 255, 136, 25),
                                    ),
                                  ),
                                ),
                                const Text(
                                  '傳送照片',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoSwitch(
                                  value: widget.isTranslate,
                                  activeColor:
                                      const Color.fromARGB(255, 255, 155, 40),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _changeTranslateStatus(newValue);
                                    });
                                  },
                                ),
                                const Text(
                                  '翻譯功能',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(
                  CupertinoIcons.bars,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: _sendMsgController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 20,
            ),
            child: GlowingActionButton(
              color: const Color.fromARGB(255, 0, 0, 0),
              icon: Icons.send_rounded,
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
