import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/post/get_translated_sentence_api.dart';
import 'package:omelet/componets/button/on_select_image_btn_pressed.dart';
import 'package:omelet/componets/button/on_send_msg_btn_pressed.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/storage/safe_config_store.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/theme/theme_constants.dart';

class MultiChatRoomPage extends StatefulWidget {
  const MultiChatRoomPage(
      {super.key,
      required this.friendsUidA,
      required this.friendsUidB,
      required this.ourUid});

  final String friendsUidA;
  final String friendsUidB;
  final String ourUid;

  @override
  State<MultiChatRoomPage> createState() => MultiChatRoomPageState();
}

class MultiChatRoomPageState extends State<MultiChatRoomPage> {
  static GlobalKey updateMultiChatKey = GlobalKey();
  final SafeConfigStore safeConfigStore = SafeConfigStore();

  bool isChangeWindow = false;
  bool isLoading = true;
  late bool isTranslateA;
  late bool isTranslateB;
  late Map<String, dynamic> friendsInfo = {};
  late List<String> debugTranslate = [];
  late Map<String, dynamic> friendsAInfo = {};
  late Map<String, dynamic> friendsBInfo = {};
  late String friendsUid;

  @override
  void initState() {
    super.initState();

    _initializeData();
  }

  void _initializeData() async {
    try {
      isTranslateA =
          await safeConfigStore.isTranslateActive(widget.friendsUidA);
      print('isTranslateA:$isTranslateA');
      isTranslateB =
          await safeConfigStore.isTranslateActive(widget.friendsUidB);

      if (isTranslateA == true && isTranslateB == false) {
        await safeConfigStore.enableTranslation(widget.friendsUidB);
      } else if (isTranslateA == true && isTranslateB == true) {
      } else if (isTranslateA == false && isTranslateB == true) {
        await safeConfigStore.disableTranslation(widget.friendsUidB);
      } else if (isTranslateA == false && isTranslateB == false) {
      } else {
        print('eorro');
      }
      var debugTranslateInit =
          await safeConfigStore.debugShowAllActiveTranslateUid();

      print('[chat_room_page] deBugTranslateList：$debugTranslateInit');
      print('isTranslateB:$isTranslateB');
      print('widget.friends_uidA:${widget.friendsUidA}');
      await Future.wait([
        _fetchUserInfo(widget.friendsUidA),
        _fetchUserInfo(widget.friendsUidB),
      ]).then((List<Map<String, dynamic>> results) {
        setState(() {
          friendsAInfo = results[0];
          friendsBInfo = results[1];
          isLoading = false;
          // 数据加载完成后执行页面刷新操作
        });
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchUserInfo(String userUid) async {
    try {
      print('_fetchUserInfo uid :$userUid');
      final response = await getUserPublicInfoApi(userUid);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print('responseData:$responseData');
      responseData['data']['uid'] = userUid;
      print('responseDatadatauid:${responseData['data']['uid']}');
      print('responseData:$responseData');
      return responseData;
    } catch (e) {
      print('get Error Msg: $e');
      return {};
    }
  }

  static currenInstanceInMultiChat() {
    var state = MultiChatRoomPageState.updateMultiChatKey.currentContext
        ?.findAncestorStateOfType();

    return state;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
      print('friendsAInfo:$friendsAInfo');
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), // 設定所需的高度
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 253, 131, 30)), // 设置边框颜色和宽度
              borderRadius: BorderRadius.circular(5), // 设置边框圆角
            ),
            child: AppBar(
              title: _AppBarTitle(
                friendsInfo: isChangeWindow ? friendsAInfo : friendsBInfo,
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(6.0), // 设置按钮的外围宽度
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isChangeWindow = !isChangeWindow;
                      });
                      print(
                          '[multi_chat_room.dart]isChangeWindow:$isChangeWindow');
                    },
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all<Size>(const Size(50, 10)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(
                                255, 250, 143, 21)) // 设置按钮的最小尺寸
                        // 其他样式属性
                        ),
                    child: const Icon(
                      Icons.change_circle,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
            ),
          ),
        ),
        key: updateMultiChatKey,
        body: Column(
          children: [
            Expanded(
              child: _ReadMessageList(
                friendsInfo: isChangeWindow ? friendsAInfo : friendsBInfo,
                isTranslate: isChangeWindow ? isTranslateA : isTranslateB,
                ourUid: widget.ourUid,
              ),
            ),
            _MiddleBar(
              friendsInfo: isChangeWindow ? friendsBInfo : friendsAInfo,
            ),
            Expanded(
              child: _ReadMessageList(
                friendsInfo: isChangeWindow ? friendsBInfo : friendsAInfo,
                isTranslate: isChangeWindow ? isTranslateA : isTranslateB,
                ourUid: widget.ourUid,
              ),
            ),
            _ActionBarForMulti(
              friendsAInfo: isChangeWindow ? friendsAInfo : friendsBInfo,
              friendsBInfo: isChangeWindow ? friendsBInfo : friendsAInfo,
              isTranslate: isTranslateA,
            ),
          ],
        ),
      );
    }
  }

  reloadDataInMulti() async {
    debugTranslate = await safeConfigStore.debugShowAllActiveTranslateUid();
    isTranslateA = await safeConfigStore.isTranslateActive(widget.friendsUidA);
    print('[chat_room_page] deBugTranslateList：$debugTranslate');
    if (mounted) {
      setState(() {
        print('chat_room_setState');
        _ReadMessageList;
      });
    }
  }
}

//==============讀取訊息=====================

class _ReadMessageList extends StatelessWidget {
  const _ReadMessageList({
    Key? key,
    required this.friendsInfo,
    required this.isTranslate,
    required this.ourUid,
  }) : super(key: key);

  final Map<String, dynamic> friendsInfo;
  final bool isTranslate;
  final String ourUid;

  Future<List<Map<String, dynamic>>> fetchAndDisplayMessagesed() async {
    print('test:${friendsInfo['data']['uid']}');
    final SafeMsgStore safeMsgStore = SafeMsgStore();
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
      future: fetchAndDisplayMessagesed(),
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

            final imageData =
                isImage ? Uint8List.fromList(imageDataInt!) : null;

            return isTranslate //判斷翻譯功能
                ? (isOwnMessage //啟用情況下
                    ? (isImage
                        ? _ImgOwnTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : _MessageOwnTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          ))
                    : (isImage
                        ? _ImgTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : _AIMessageTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                            ourUid: ourUid,
                          )))
                : (isOwnMessage //非啟用情況
                    ? (isImage
                        ? _ImgOwnTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : _MessageOwnTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          ))
                    : (isImage
                        ? _ImgTitle(
                            imageData: imageData,
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )
                        : _MessageTitle(
                            message: realmessage['content'],
                            messageDate: DateFormat('MMMM/d h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(timestamp),
                            ),
                          )));
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _MiddleBar extends StatelessWidget {
  _MiddleBar({Key? key, required this.friendsInfo}) : super(key: key);

  final Map<String, dynamic> friendsInfo;

  String? _pfpUrl;

  @override
  Widget build(BuildContext context) {
    if (friendsInfo['data']['pfp'] != null) {
      _pfpUrl = friendsInfo['data']['pfp'];
    } else {
      _pfpUrl = null;
    }

    Widget avatarWidget = _pfpUrl == null
        ? const Padding(
            padding: EdgeInsets.all(1.0),
            child: Icon(
              Icons.egg_alt_rounded,
              size: 35,
              color: Color.fromARGB(255, 238, 108, 33),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(1.0),
            child: Avatar.sm(
              url: _pfpUrl,
            ),
          );

    print('[chat_room_page] 該好友資訊：$friendsInfo');
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 253, 131, 30)), // 设置边框颜色和宽度
        borderRadius: BorderRadius.circular(5), // 设置边框圆角
      ),
      padding: const EdgeInsets.all(8), // 设置内边距
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          avatarWidget,
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendsInfo['data']['username'],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _AppBarTitle extends StatelessWidget {
  _AppBarTitle({Key? key, required this.friendsInfo}) : super(key: key);
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
              size: 35,
              color: Color.fromARGB(255, 238, 108, 33),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Avatar.sm(
              url: pfpUrl,
            ),
          );

    print('[chat_room_page] 該好友資訊：$friendsInfo');
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

class _MessageTitle extends StatelessWidget {
  //好友的訊息框
  const _MessageTitle(
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
                        horizontal: 20.0, vertical: 15),
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

class _MessageOwnTitle extends StatelessWidget {
  //自己的訊息框
  const _MessageOwnTitle(
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
                        horizontal: 20.0, vertical: 15),
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

class _ImgTitle extends StatelessWidget {
  //圖片訊息框
  const _ImgTitle({
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
                    height: 150,
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

class _ImgOwnTitle extends StatelessWidget {
  const _ImgOwnTitle({
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
                    height: 150,
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

class _AIMessageTitle extends StatefulWidget {
  const _AIMessageTitle({
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
  State<_AIMessageTitle> createState() => _AIMessageTitleState();
}

class _AIMessageTitleState extends State<_AIMessageTitle> {
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
                  topLeft: Radius.circular(_AIMessageTitle._borderRadius),
                  topRight: Radius.circular(_AIMessageTitle._borderRadius),
                  bottomRight: Radius.circular(_AIMessageTitle._borderRadius),
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

class _ActionBarForMulti extends StatefulWidget {
  const _ActionBarForMulti(
      {Key? key,
      required this.isTranslate,
      required this.friendsAInfo,
      required this.friendsBInfo})
      : super(key: key);
  final Map<String, dynamic> friendsAInfo;
  final Map<String, dynamic> friendsBInfo;
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
      // TODO: V2 為新版
      await onSendMsgBtnPressed(
          widget.friendsAInfo['data']['uid'], _sendMsgController.text);
      // await v2OnSendMsgBtnPressed(
      //     widget.friendsInfo['data']['uid'], _sendMsgController.text);
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
      print(
          '[multi_chat_room]widget.friendsInfo${widget.friendsAInfo['data']['uid']}');
      await safeConfigStore
          .enableTranslation(widget.friendsAInfo['data']['uid']);
      await safeConfigStore
          .enableTranslation(widget.friendsBInfo['data']['uid']);
    } else {
      await safeConfigStore
          .disableTranslation(widget.friendsAInfo['data']['uid']);
      await safeConfigStore
          .disableTranslation(widget.friendsBInfo['data']['uid']);
    }

    var debugTranslate = await safeConfigStore.debugShowAllActiveTranslateUid();

    print('[chat_room_page] deBugTranslateList：$debugTranslate');
    setState(() {
      MultiChatRoomPageState.currenInstanceInMultiChat()?.reloadDataInMulti();
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
                                        '[chat_room_page.dart]uid:${widget.friendsAInfo['data']['uid']}');
                                    onSelectImageBtnPressed(
                                        widget.friendsAInfo['data']['uid']);
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
                  hintText: 'Reply to the message above...',
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
