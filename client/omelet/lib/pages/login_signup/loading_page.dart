import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/nav_bar_control_page.dart';
import 'package:omelet/pages/login_signup/login_page.dart';
import 'package:omelet/utils/current_active_account.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/utils/check_opk_status.dart';
import 'package:omelet/utils/check_spk_status.dart';
import 'package:omelet/utils/check_unread_msg.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/storage/safe_notify_store.dart';
import 'package:omelet/storage/safe_config_store.dart';
import 'package:omelet/utils/check_unread_notify.dart';

late io.Socket socket;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  bool _isLoading = true;

  SafeConfigStore safeConfigStore = SafeConfigStore();

  @override
  void initState() {
    super.initState();
    waitForIsShowUserPage();
  }

  Future<void> waitForIsShowUserPage() async {
    // 停止加載
    setState(() {
      _isLoading = false;
    });
    await initSocket(); // 等待 3 秒後開始初始化Socket
  }

  Future<void> initSocket() async {
    print('[loading_page] 初始狀態檢查開始 --------------------');
    try {
      // TODO: 刪除所有儲存空間、PreKeyBundle、UnreadMsg，debug 用
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      print('[loading_page] 已刪除所有儲存空間');
      // final res = await debugResetPrekeyBundleAndUnreadMsgApi();
      // print('[loading_page.dart] ${jsonDecode(res.body)}');

      // JWT 存在，直接連線到 Socket.io Server
      if (await isCurrentActiveAccountExsist()) {
        print('[loading_page] currentActiveAccount 存在✅');

        final (token, ipkPub) = await loadJwtAndIpkPub();

        socket = io.io(
          serverUri,
          io.OptionBuilder().setTransports(['websocket']).build(),
        );

        socket.onConnect((_) async {
          final safeNotifyStore = SafeNotifyStore();
          print(
              '[loading_page] 所有通知內容：${await safeNotifyStore.readAllNotifications()}');

          // 回傳 JWT，驗證身份
          socket.emit(
            'clientReturnJwtToServer',
            {'token': token, 'ipkPub': ipkPub},
          );

          socket.on('jwtValid', (data) async {
            print('[loading_page] 已連接至後端');
            print('[loading_page] 本裝置的 socket.id 為： ${socket.id}');

            // 若伺服器中自己的 OPK 耗盡，則產生並上傳 OPK
            await checkOpkStatus();

            // 若伺服器中自己的 SPK 期限已到（7 天），則產生並上傳 SPK
            await checkSpkStatus();

            // 若有未讀訊息，則儲存到本地
            await checkUnreadMsg();

            // 若有未讀通知，則儲存到本地
            await checkUnreadNotify();

            String ourUid = await loadCurrentActiveAccount();

            String getTranslate =
                await safeConfigStore.getTranslationDestLang(ourUid);
            if (getTranslate == 'null') {
              await safeConfigStore.setTranslationDestLang(ourUid, 'Chinese');
            }
            getTranslate = await safeConfigStore.getTranslationDestLang(ourUid);
            print('[loading_page.dart]getTranslate:$getTranslate');
            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NavBarControlPage(ourUid: ourUid)));
            }
          });

          socket.on('serverForwardMsgToClient', (msg) async {
            print('--------------------------------');
            print('[main.dart] 已接收訊息👉 $msg');
            print('--------------------------------\n');
            final safeMsgStore = SafeMsgStore();
            await safeMsgStore.storeReceivedMsg(msg);
            print('[loading_page.dart] 新增新接收到的訊息，模擬顯示在聊天室上');
            print('[loading_page.dart] 接收到資料：$msg');
            // 接收訊息時：顯示一則新訊息在聊天室
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
            // 顯示好友邀請
          });

          socket.on('acceptedFriendRequest', (msg) async {
            print('--------------------------------');
            print('[main.dart] 對方已同意好友邀請👉 $msg');
            print('--------------------------------\n');
            await safeNotifyStore.writeNotification(jsonDecode(msg));
            //  顯示「對方已同意好友邀請」
          });
        });

        socket.on(
            'disconnect', (_) => print('[loading_page.dart] 已與後端伺服器斷開連接🈹'));

        // 後端檢查 JWT 是否過期
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
        print(
            '[main.dart] currentActiveAccount 不存在❌\n該使用者第一次開啟 App，應跳轉至登入頁面並產生公鑰包\n');
        String ourUid = await loadCurrentActiveAccount();
        await safeConfigStore.setTranslationDestLang(ourUid, 'Chinese');
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
        : const Scaffold(body: Center(child: Text('加載中'))); // 或其他 UI
  }
}
