import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:test_im_v4/api/post/update_opk.dart';
import 'package:test_im_v4/api/post/update_spk.dart';

import 'package:test_im_v4/utils/jwt.dart';
import 'package:test_im_v4/utils/load_local_info.dart';
import 'package:test_im_v4/utils/login.dart';
import 'package:test_im_v4/api/get/get_self_opk_status_api.dart';
import 'package:test_im_v4/api/get/get_self_spk_status_api.dart';
import 'package:test_im_v4/signal_protocol/generate_and_store_key.dart';
import 'package:test_im_v4/signal_protocol/safe_opk_store.dart';
import 'package:test_im_v4/signal_protocol/safe_spk_store.dart';
import 'package:test_im_v4/signal_protocol/safe_identity_store.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test_im_v4/api/get/get_unread_msg_api.dart';
import 'package:test_im_v4/message/safe_msg_store.dart';

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
        final getSelfOpkStatusRes = await getSelfOpkStatus();
        final getSelfOpkStatusResBody = jsonDecode(getSelfOpkStatusRes.body);
        print(
            '[main.dart] getSelfOpkStatusResBody 內容：$getSelfOpkStatusResBody');

        final outOfOpk = getSelfOpkStatusResBody['data']['outOfOpk'];
        final lastBatchMaxOpkId =
            getSelfOpkStatusResBody['data']['lastBatchMaxOpkId'];

        if (outOfOpk) {
          final newOpks = generatePreKeys(lastBatchMaxOpkId + 1, 100);

          final res = await updateOpk(jsonEncode({
            for (var newOpk in newOpks)
              newOpk.id.toString():
                  jsonEncode(newOpk.getKeyPair().publicKey.serialize())
          }));
          print('--------------------------------');
          print('[main.dart] new opk👉 ${res.body}');
          print('--------------------------------\n');

          final opkStore = SafeOpkStore();
          for (final newOpk in newOpks) {
            await opkStore.storePreKey(newOpk.id, newOpk);
          }
        }

        // 若伺服器中自己的 SPK 期限已到（7 天），則產生並上傳 SPK
        final getSelfSpkStatusRes = await getSelfSpkStatus();
        final getSelfSpkStatusResBody = jsonDecode(getSelfSpkStatusRes.body);
        print('[main.dart] getSelfSpkStatusResBody: $getSelfSpkStatusResBody');
        final spkStatus = getSelfSpkStatusResBody['data'];
        final spkExpired = spkStatus['spkExpired'];
        final lastBatchSpkId = spkStatus['lastBatchSpkId'];

        if (spkExpired) {
          final ipkStore = SafeIdentityKeyStore();
          final selfIpk = await ipkStore.getIdentityKeyPair();
          final newSpk = generateSignedPreKey(selfIpk, lastBatchSpkId + 1);

          final res = await updateSpk(
            jsonEncode({
              newSpk.id.toString():
                  jsonEncode(newSpk.getKeyPair().publicKey.serialize())
            }),
            jsonEncode({newSpk.id.toString(): jsonEncode(newSpk.signature)}),
          );
          print('[main.dart] 更新 SPK👉 ${res.body}');

          final spkStore = SafeSpkStore();
          await spkStore.storeSignedPreKey(newSpk.id, newSpk);
        }

        // 取得未讀訊息
        final getUnreadMsgAPIRes = await getUnreadMsgAPI();
        final List<dynamic> unreadMsgs =
            jsonDecode(getUnreadMsgAPIRes.body)['data'];
        print('[main.dart] 未讀訊息👉 $unreadMsgs');

        // 儲存未讀訊息
        if (unreadMsgs.isNotEmpty) {
          final safeMsgStore = SafeMsgStore();
          await safeMsgStore.sortAndstoreUnreadMsg(unreadMsgs);
        }
      });

      // 接收伺服器轉發的訊息
      socket.on('serverForwardMsgToClient', (msg) async {
        print('--------------------------------');
        print('[main.dart] 已接收訊息👉 $msg');
        final safeMsgStore = SafeMsgStore();
        await safeMsgStore.storeReceivedMsg(msg);
        print('--------------------------------\n');
      });
    });

    socket.on('jwtExpired', (data) async {
      print('--------------------------------');
      print('[main.dart] JWT expired');
      print('--------------------------------\n');
      // 後端檢查 JWT 是否過期
      // 跳轉至登入頁面
      await login(username, password);
      socket.emit('clientReturnJwtToServer', await storage.read(key: 'token'));
    });
  } else {
    print('[main.dart] jwt 不存在❌\n該使用者第一次開啟 App，應跳轉至登入頁面並產生公鑰包\n');
    await login(username, password);
    await generateAndStoreKey();
    await initSocket();
  }
}
