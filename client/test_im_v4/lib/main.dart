import 'package:flutter/material.dart';
import 'package:test_im_v4/widget/read_all_storage_btn.dart';

final hintMsgKey = GlobalKey();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String hintMsg = '這是測試訊息UwU';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // 用 SingleChildScrollView 確保垂直方向塞的下所有 widget
        body: SingleChildScrollView(
            // 用 Column 垂直排列 widget
            child: Column(children: [
          // 保留頂部空間
          const SizedBox(height: 50),
          ReadAllStorageBtn(updateHintMsg),

          // 提示訊息（除錯用）
          Text(
            hintMsg,
            textDirection: TextDirection.ltr,
            key: hintMsgKey,
          ),
        ])),
      ),
    );
  }

  void updateHintMsg(String newHintMsg) {
    setState(() {
      hintMsg = newHintMsg;
    });
  }
}
