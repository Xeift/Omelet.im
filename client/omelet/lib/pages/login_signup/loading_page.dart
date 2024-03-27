import 'package:flutter/material.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/nav_bar_control_page.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:omelet/pages/login_signup/login_page.dart';
import 'package:omelet/utils/jwt.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/utils/check_opk_status.dart';
import 'package:omelet/utils/check_spk_status.dart';
import 'package:omelet/utils/check_unread_msg.dart';
import 'package:omelet/message/safe_msg_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omelet/api/debug_reset_prekeybundle_and_unread_msg.dart';
import 'dart:convert';
import 'package:omelet/message/safe_notify_store.dart';

late io.Socket socket;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    waitForIsShowUserPage();
  }

  Future<void> waitForIsShowUserPage() async {
    await Future.delayed(const Duration(seconds: 3));
    // 停止加载
    setState(() {
      _isLoading = false;
    });
    await initSocket(); // 等待3秒後開始初始化Socket
  }

  Future<void> initSocket() async {
    try {
      // TODO: 刪除所有儲存空間、PreKeyBundle、UnreadMsg，debug 用
      // const storage = FlutterSecureStorage();
      // await storage.deleteAll();
      // final res = await debugResetPrekeyBundleAndUnreadMsgApi();
      // print('[loading_page.dart] ${jsonDecode(res.body)}');

      print(await isJwtExsist());
      if (await isJwtExsist()) {
        final (token, ipkPub) = await loadJwtAndIpkPub();

        socket = io.io(
          serverUri,
          io.OptionBuilder().setTransports(['websocket']).build(),
        );

        socket.onConnect((_) async {
          final safeNotifyStore = SafeNotifyStore();
          print('所有通知內容：${await safeNotifyStore.readAllNotifications()}');

          socket.emit(
              'clientReturnJwtToServer', {'token': token, 'ipkPub': ipkPub});

          socket.on('jwtValid', (data) async {
            print('--------------------------------');
            print('[loading_page.dart] 已連接至後端');
            print('[loading_page.dart] socket.id = ${socket.id}');
            print('--------------------------------\n');

            await checkOpkStatus();
            await checkSpkStatus();
            await checkUnreadMsg();
            await getUserUid();

            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NavBarControlPage()));
            }
          });

          socket.on('serverForwardMsgToClient', (msg) async {
            print('--------------------------------');
            print('[main.dart] 已接收訊息👉 $msg');
            print('--------------------------------\n');
            final safeMsgStore = SafeMsgStore();
            await safeMsgStore.storeReceivedMsg(msg);
            print('[loading_page.dart]新增新接收到的訊息，模擬顯示在聊天室上');
            print('[loading_page.dart]接收到資料：{$msg}');
            // TODO: 接收訊息時：顯示一則新訊息在聊天室
            ChatRoomPageState.currenInstance()?.reloadData();
          });

          socket.on('receivedFriendRequest', (msg) async {
            print('--------------------------------');
            print('[main.dart] 已接收到好友邀請👉 $msg');
            print('--------------------------------\n');

            print('[loading_page] ${jsonDecode(msg).runtimeType}');

            // 儲存好友邀請
            await safeNotifyStore.writeNotification(jsonDecode(msg));
            print('[loading_page] 完成');
            // TODO: 顯示好友邀請
          });

          socket.on('acceptedFriendRequest', (msg) async {
            print('--------------------------------');
            print('[main.dart] 對方已同意好友邀請👉 $msg');
            print('--------------------------------\n');
            await safeNotifyStore.writeNotification(jsonDecode(msg));
            // TODO: 顯示「對方已同意好友邀請」
          });
        });

        socket.on(
            'disconnect', (_) => print('[loading_page.dart] 已與後端伺服器斷開連接🈹'));

        socket.on('jwtExpired', (data) async {
          print('--------------------------------');
          print('[main.dart] JWT expired');
          print('--------------------------------\n');

          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginPage(
                      title: '',
                    )));
            return;
          }

          final (token, ipkPub) = await loadJwtAndIpkPub();
          socket.emit(
              'clientReturnJwtToServer', {'token': token, 'ipkPub': ipkPub});
        });
      } else {
        print('[main.dart] jwt 不存在❌\n該使用者第一次開啟 App，應跳轉至登入頁面並產生公鑰包\n');

        if (mounted) {
          print('觸發跳轉');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LoginPage(
                    title: '',
                  )));
          return;
        }
      }
    } catch (e) {
      // 錯誤處理
      print('錯誤：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // 顯示載入指示器
            ),
          )
        : const Scaffold(); // 或其他 UI
  }
}
