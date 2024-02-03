import 'package:flutter/material.dart';

import '../componets/Screen/frosted_appbr.dart';
import '../pages/setting/setting_page.dart';



class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
   // ignore: library_private_types_in_public_api
   _ChatListPageState createState() =>  _ChatListPageState();
}
class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child:Stack(
          fit: StackFit.expand,
          children: [
            FrostedAppbar(//引用AppBar套件
                blurStrengthX: 10,
                blurStrengthY: 10,
                actions: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SettingPage()));
                      },
                      child: Icon(Icons.settings),
                    ),
                ],
                leading: const Icon(Icons.account_circle),
                title: const Center(
                  child:Text('Chat',//AppBar title 的文字
                    style: TextStyle(fontSize: 20,color:Colors.black),) ,),
                  color: Colors.orange.withAlpha(30),
              ),
           ],
          ),
        ),
      ),
    );
  }
}
