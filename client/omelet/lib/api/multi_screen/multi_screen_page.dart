// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:omelet/api/get/get_user_public_info_api.dart';
// import 'package:omelet/pages/message/chat_room_page.dart';
// import 'package:omelet/storage/safe_config_store.dart';

// class MultiScreenPage extends StatefulWidget {
//   const MultiScreenPage({Key? key}) : super(key: key);

//   @override
//   State<MultiScreenPage> createState() => _MultiScreenPageState();
// }

// class _MultiScreenPageState extends State<MultiScreenPage> {
//   SafeConfigStore safeConfigStore = SafeConfigStore();
//   late Map<String, dynamic> friendsInfo = {};

//   String friendsA_Uid = '552415467919118336';

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   void _initializeData() async {
//     var isTranslate = await safeConfigStore.isTranslateActive(friendsA_Uid);
//     print('[chat_room_page] 該使用者翻譯功能狀態：$isTranslate');
//     _fetchUserInfo().then((userInfo) {
//       if (mounted) {
//         setState(() {
//           friendsInfo = userInfo;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Test',
//       home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           body: SafeArea(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   color: Colors.greenAccent,
//                   height: MediaQuery.of(context).size.height / 2.2,  // Also Including Tab-bar height.
//                 ),
//                 if (friendsInfo.isEmpty) ...[
//                   Center(
//                     child: Semantics(
//                       excludeSemantics: true,
//                       child: const LinearProgressIndicator(
//                         minHeight: 6,
//                         backgroundColor: Color.fromARGB(255, 2, 2, 2),
//                         valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 243, 128, 33)),
//                       ),
//                     ),
//                   ),
//                 ] else ...[
//                   ReadMessageList(ourUid: '561550071007547392', friendsInfo: {},),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _fetchUserInfo() async {
//     try {
//       final response = await getUserPublicInfoApi(friendsA_Uid);
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       responseData['data']['uid'] = friendsA_Uid;
//       return responseData;
//     } catch (e) {
//       print('get Error Msg: $e');
//       return {};
//     }
//   }
// }

