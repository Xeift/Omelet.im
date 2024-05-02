import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';

import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/post/get_translated_sentence_api.dart';
import 'package:omelet/componets/button/v2_on_select_image_btn_pressed.dart';
import 'package:omelet/componets/button/v2_on_send_msg_btn_pressed.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/storage/safe_config_store.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/theme/theme_constants.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.friendsUid, required this.ourUid})
      : super(key: key);
  final String friendsUid;
  final String ourUid;

  @override
  State<ChatRoomPage> createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  static GlobalKey updateChatKey = GlobalKey();
  final SafeConfigStore safeConfigStore = SafeConfigStore();
  late String friendsUid;
  late bool isTranslate;
  late Map<String, dynamic> friendsInfo = {};
  late List<String> debugTranslate = [];

  @override
  void initState() {
    super.initState();
    friendsUid = widget.friendsUid;
    _initializeData();
  }

  void _initializeData() async {
    isTranslate = await safeConfigStore.isTranslateActive(friendsUid);
    _fetchUserInfo().then((userInfo) {
      if (mounted) {
        setState(() {
          friendsInfo = userInfo;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchUserInfo() async {
    try {
      final response = await getUserPublicInfoApi(friendsUid);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      responseData['data']['uid'] = widget.friendsUid;
      return responseData;
    } catch (e) {
      print('get Error Msg: $e');
      return {};
    }
  }

  static currenInstance() {
    var state = ChatRoomPageState.updateChatKey.currentContext
        ?.findAncestorStateOfType();

    return state;
  }

  @override
  Widget build(BuildContext context) {
    if (friendsInfo.isEmpty) {
      return Scaffold(
        body: Center(
          child: Semantics(
            excludeSemantics: true,
            child: const LinearProgressIndicator(
              minHeight: 6,
              backgroundColor: Color.fromARGB(255, 2, 2, 2),
              valueColor:
                  AlwaysStoppedAnimation(Color.fromARGB(255, 243, 128, 33)),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65), // 設定所需的高度
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: AppBarTitle(
                  friendsInfo: friendsInfo,
                ),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 0,
              ),
            ),
          ),
        ),
        key: updateChatKey,
        body: Column(
          children: [
            Expanded(
              child: ReadMessageList(
                friendsInfo: friendsInfo,
                isTranslate: isTranslate,
                ourUid: widget.ourUid,
              ),
            ),
            _ActionBar(
              friendsInfo: friendsInfo,
              isTranslate: isTranslate,
            ),
          ],
        ),
      );
    }
  }

  reloadData() async {
    debugTranslate = await safeConfigStore.debugShowAllActiveTranslateUid();
    isTranslate = await safeConfigStore.isTranslateActive(friendsUid);
    if (mounted) {
      setState(() {
        print('chat_room_setState');
        ReadMessageList;
        AIMessageTitle;
      });
    }
  }
}

// ignore: must_be_immutable
class AppBarTitle extends StatelessWidget {
  AppBarTitle({Key? key, required this.friendsInfo}) : super(key: key);
  final Map<String, dynamic> friendsInfo;

  String? pfpUrl;

  @override
  Widget build(BuildContext context) {
    if (friendsInfo['data']['pfp'] != null) {
      pfpUrl = friendsInfo['data']['pfp'];
    } else {
      pfpUrl = null;
    }

    Widget avatarWidget = pfpUrl == null
        ? const Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.egg_alt_rounded,
              size: 43,
              color: Color.fromARGB(255, 238, 108, 33),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Avatar.sm(
              url: pfpUrl,
            ),
          );

    return Row(
      children: [
        avatarWidget,
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friendsInfo['data']['username'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReadMessageList extends StatelessWidget {
  final SafeMsgStore safeMsgStore = SafeMsgStore();

  ReadMessageList(
      {super.key,
      required this.friendsInfo,
      required this.isTranslate,
      required this.ourUid});
  final Map<String, dynamic> friendsInfo;
  final bool isTranslate;
  final String ourUid;
  Future<List<Map<String, dynamic>>> fetchAndDisplayMessages() async {
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
                realmessage['sender'].toString() != ourUid; //訊息數否為寄送者
            final isImage = realmessage['type'] != 'text';
            var imageDataInt = isImage //判斷訊息是否為圖片
                ? (realmessage['content'] as String)
                    .substring(1, realmessage['content'].length - 1)
                    .split(',')
                    .map((String byteString) => int.parse(byteString.trim()))
                    .toList()
                : null;

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

class MessageTitle extends StatelessWidget {
  //好友的訊息框
  const MessageTitle(
      {Key? key, required this.message, required this.messageDate})
      : super(key: key);

  final String message;
  final String messageDate;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 198, 198, 198),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_borderRadius),
                      topRight: Radius.circular(_borderRadius),
                      bottomRight: Radius.circular(_borderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(messageDate,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
        ));
  }
}

class MessageOwnTitle extends StatelessWidget {
  //自己的訊息框
  const MessageOwnTitle(
      {Key? key, required this.message, required this.messageDate})
      : super(key: key);

  final String message;
  final String messageDate;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    print('[chat_room_page]訊息框:$message');
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_borderRadius),
                      bottomRight: Radius.circular(_borderRadius),
                      bottomLeft: Radius.circular(_borderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Text(message,
                        style: const TextStyle(
                          color: AppColors.textLigth,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(messageDate,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
        ));
  }
}

class DateLable extends StatelessWidget {
  //訊息視覺話處理
  const DateLable({Key? key, required this.lable}) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(lable,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )))),
    ));
  }
}

class ImgTitle extends StatelessWidget {
  //圖片訊息框
  const ImgTitle({
    Key? key,
    required this.imageData,
    required this.messageDate,
  }) : super(key: key);

  final Uint8List? imageData;
  final String messageDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InstaImageViewer(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  child: Image.memory(
                    imageData!,
                    height: 200,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                messageDate,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImgOwnTitle extends StatelessWidget {
  const ImgOwnTitle({
    Key? key,
    required this.imageData,
    required this.messageDate,
  }) : super(key: key);

  final Uint8List? imageData;
  final String messageDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InstaImageViewer(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  child: Image.memory(
                    imageData!,
                    height: 200,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                messageDate,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AIMessageTitle extends StatefulWidget {
  const AIMessageTitle({
    Key? key,
    required this.message,
    required this.messageDate,
    required this.ourUid,
  }) : super(key: key);

  final String message;
  final String messageDate;
  final String ourUid;

  static const _borderRadius = 26.0;

  @override
  State<AIMessageTitle> createState() => _AIMessageTitleState();
}

class _AIMessageTitleState extends State<AIMessageTitle> {
  @override
  Widget build(BuildContext context) {
    final safeConfigStore = SafeConfigStore();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 198, 198, 198),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AIMessageTitle._borderRadius),
                  topRight: Radius.circular(AIMessageTitle._borderRadius),
                  bottomRight: Radius.circular(AIMessageTitle._borderRadius),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  FutureBuilder<String>(
                    future: _getTranslatedMessage(
                        widget.message, widget.ourUid, safeConfigStore),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink(); // 不顯示任何內容
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final translatedMsg = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, right: 10, left: 10),
                          child: Text(translatedMsg),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.messageDate,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getTranslatedMessage(
    String message,
    String ourUid,
    SafeConfigStore safeConfigStore,
  ) async {
    String translateLanguage =
        await safeConfigStore.getTranslationDestLang(ourUid);
    print('[chat_room_page.dart]使用語言:$translateLanguage');
    var res = await getTranslatedSentenceApi(message, translateLanguage);
    var resBody = jsonDecode(res.body);
    return resBody['data'];
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar(
      {Key? key, required this.friendsInfo, required this.isTranslate})
      : super(key: key);
  final Map<String, dynamic> friendsInfo;
  final bool isTranslate;

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
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
      await v2OnSendMsgBtnPressed(
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
                                    v2OnSelectImageBtnPressed(
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
                                  'Photo library',
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
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'AI Translation',
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
              right: 5,
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(50, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary), // 设置按钮的最小尺寸
                // 其他样式属性
              ),
              onPressed: _sendMessage,
              child: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
