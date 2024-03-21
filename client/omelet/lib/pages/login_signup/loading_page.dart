import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    initSocket(); // 等待3秒後開始初始化Socket
  }

  Future<void> initSocket() async {
    try {
      // TODO: storage debug
      // const storage = FlutterSecureStorage();
      // await storage.deleteAll();

      print(await isJwtExsist());
      if (await isJwtExsist()) {
        final (token, ipkPub) = await loadJwtAndIpkPub();

        socket = io.io(
          serverUri,
          io.OptionBuilder().setTransports(['websocket']).build(),
        );

        socket.onConnect((_) async {
          socket.emit(
              'clientReturnJwtToServer', {'token': token, 'ipkPub': ipkPub});

          socket.on('jwtValid', (data) async {
            print('--------------------------------');
            print('[main.dart] backend connected');
            print('--------------------------------\n');

            await checkOpkStatus();
            await checkSpkStatus();
            await checkUnreadMsg();
            await getUserUid();

            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NavBarControlPage()));
              return;
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
            MessageTitle(
                      message: msg['content'],
                      messageDate: DateFormat('h:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
                      ),
             );
          });
        });

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
