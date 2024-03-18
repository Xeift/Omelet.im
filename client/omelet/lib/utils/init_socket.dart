// ignore_for_file: avoid_print

import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:omelet/utils/jwt.dart';
// import 'package:omelet/utils/login.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/utils/check_opk_status.dart';
import 'package:omelet/utils/check_spk_status.dart';
import 'package:omelet/utils/check_unread_msg.dart';

import 'package:omelet/signal_protocol/generate_and_store_key.dart';

import 'package:omelet/message/safe_msg_store.dart';

late io.Socket socket;

Future<void> initSocket() async {
  // JWT 存在，直接連線到 Socket.io Server
  if (await isJwtExsist()) {
    final (token, ipkPub) = await loadJwtAndIpkPub();

    socket = io.io(
        serverUri, io.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) async {
      // 回傳 JWT，驗證身份
      socket
          .emit('clientReturnJwtToServer', {'token': token, 'ipkPub': ipkPub});

      socket.on('jwtValid', (data) async {
        print('--------------------------------');
        print('[main.dart] backend connected');
        print('--------------------------------\n');

        // 若伺服器中自己的 OPK 耗盡，則產生並上傳 OPK
        await checkOpkStatus();

        // 若伺服器中自己的 SPK 期限已到（7 天），則產生並上傳 SPK
        await checkSpkStatus();

        // 若有未讀訊息，則儲存到本地
        await checkUnreadMsg();

        // TODO: 跳轉至聊天列表畫面
      });

      // 接收伺服器轉發的訊息
      socket.on('serverForwardMsgToClient', (msg) async {
        print('--------------------------------');
        print('[main.dart] 已接收訊息👉 $msg');
        print('--------------------------------\n');
        final safeMsgStore = SafeMsgStore();
        await safeMsgStore.storeReceivedMsg(msg);
      });
    });

    // 後端檢查 JWT 是否過期
    socket.on('jwtExpired', (data) async {
      print('--------------------------------');
      print('[main.dart] JWT expired');
      print('--------------------------------\n');
      // TODO: 跳轉至登入頁面
      // await login(username, password);
      final (token, ipkPub) = await loadJwtAndIpkPub();
      socket
          .emit('clientReturnJwtToServer', {'token': token, 'ipkPub': ipkPub});
    });
  } else {
    print('[main.dart] jwt 不存在❌\n該使用者第一次開啟 App，應跳轉至登入頁面並產生公鑰包\n');
    // TODO: 跳轉至登入頁面
    // await login(username, password);
    await generateAndStoreKey();
    await initSocket();
  }
}
