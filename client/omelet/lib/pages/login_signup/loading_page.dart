import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/pages/message/multi_screen/multi_chat_room.dart';
import 'package:omelet/pages/notification_page/notification_page.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:permission_handler/permission_handler.dart';

import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/nav_bar_control_page.dart';
import 'package:omelet/pages/login_signup/login_page.dart';
import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/utils/check_opk_status.dart';
import 'package:omelet/utils/check_spk_status.dart';
import 'package:omelet/utils/check_unread_msg.dart';
import 'package:omelet/utils/check_device_id.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/storage/safe_notify_store.dart';
import 'package:omelet/storage/safe_config_store.dart';
import 'package:omelet/storage/safe_device_id_store.dart';
import 'package:omelet/utils/check_unread_notify.dart';
import 'package:omelet/notify/notify.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omelet/api/debug_reset_prekeybundle_and_unread_msg.dart';

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
    setState(() {
      _isLoading = false; // 停止加載
    });
    await initSocket(); // 等待 3 秒後開始初始化 Socket
  }

  Future<void> initSocket() async {
    try {
      PermissionStatus permission = await Permission.notification.status;
      if (permission.isDenied) {
        Permission.notification.request();
      }
      String ourUid = await loadCurrentActiveAccount();

      String getTranslate =
          await safeConfigStore.getTranslationDestLang(ourUid);
      if (getTranslate == 'null') {
        await safeConfigStore.setTranslationDestLang(
            ourUid, 'Chinese Traditional');
      } else if (getTranslate == 'Chinese') {
        await safeConfigStore.setTranslationDestLang(
            ourUid, 'Chinese Traditional');
      }
      getTranslate = await safeConfigStore.getTranslationDestLang(ourUid);

      // TODO: 刪除所有儲存空間、PreKeyBundle、UnreadMsg，debug 用
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      print('[loading_page] 已刪除所有儲存空間');
      final res = await debugResetPrekeyBundleAndUnreadMsgApi();
      print('[loading_page.dart] ${jsonDecode(res.body)}');

      // JWT 存在，直接連線到 Socket.io Server
      if (await isCurrentActiveAccountExsist()) {
        final token = await loadJwt();
        final safeDeviceIdStore = SafeDeviceIdStore();
        final deviceId = await safeDeviceIdStore.getLocalDeviceId();

        socket = io.io(
          serverUri,
          io.OptionBuilder().setTransports(['websocket']).build(),
        );

        // 回傳 JWT，驗證身份
        socket.emit(
          'clientReturnJwtToServer',
          {'token': token, 'deviceId': deviceId},
        );

        socket.onConnect((_) async {
          final safeNotifyStore = SafeNotifyStore();

          // // 回傳 JWT，驗證身份
          // socket.emit(
          //   'clientReturnJwtToServer',
          //   {'token': token, 'ipkPub': ipkPub},
          // );

          socket.on('jwtValid', (data) async {
            // 若伺服器中自己的 OPK 耗盡，則產生並上傳 OPK
            await checkOpkStatus();

            // 若伺服器中自己的 SPK 期限已到（7 天），則產生並上傳 SPK
            await checkSpkStatus();

            // 若有未讀訊息，則儲存到本地
            await checkUnreadMsg();

            // 若有未讀通知，則儲存到本地
            await checkUnreadNotify();

            // 更新裝置 id 資訊並儲存到本地
            await checkDeviceId();

            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NavBarControlPage(ourUid: ourUid)));
            }
          });

          socket.on('serverForwardMsgToClient', (msg) async {
            final safeMsgStore = SafeMsgStore();
            final (senderName, decryptedMsg) =
                await safeMsgStore.storeReceivedMsg(msg);
            final notify = NotificationService();
            await notify.showNotify('From $senderName:', decryptedMsg);
            ChatRoomPageState.currenInstance()?.reloadData();
            MultiChatRoomPageState.currenInstanceInMultiChat()
                ?.reloadDataInMulti();
          });

          socket.on('receivedFriendRequest', (msg) async {
            // 儲存好友邀請
            await safeNotifyStore.writeNotification(jsonDecode(msg));
            NotificationPageState.currenInstanceForNoti()?.reloadDataNoti();
            // 顯示好友邀請
          });

          socket.on('acceptedFriendRequest', (msg) async {
            await safeNotifyStore.writeNotification(jsonDecode(msg));
            final res =
                await getUserPublicInfoApi(jsonDecode(msg)['targetUid']);
            final resJson = jsonDecode(res.body);
            String notifyFriendsInfo = resJson['data']['username'];

            // 更新裝置 id 資訊並儲存到本地
            await checkDeviceId();

            // 顯示「對方已同意好友邀請」
            final notify = NotificationService();
            await notify.showNotify('Friend confirmation received',
                '$notifyFriendsInfo accepted your friend request.');
          });

          socket.on('friendsDevicesUpdated', (msg) async {
            // 更新裝置 id 資訊並儲存到本地
            await safeDeviceIdStore.updateTheirDeviceIds(
                msg['friendUid'], msg['friendNewDevicesIds']);
          });
        });

        socket.on(
            'disconnect', (_) => print('[loading_page.dart] 已與後端伺服器斷開連接🈹'));

        // 後端檢查 JWT 是否過期
        socket.on('jwtExpired', (data) async {
          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginPage(
                      title: '',
                    )));
            return;
          }

          final token = await loadJwt();
          final safeDeviceIdStore = SafeDeviceIdStore();
          final deviceId = await safeDeviceIdStore.getLocalDeviceId();
          socket.emit('clientReturnJwtToServer',
              {'token': token, 'deviceId': deviceId});
        });
      } else {
        String ourUid = await loadCurrentActiveAccount();
        await safeConfigStore.setTranslationDestLang(
            ourUid, 'Chinese Traditional');
        if (mounted) {
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
        : const Scaffold(body: Center(child: Text('Loading'))); // 或其他 UI
  }
}
