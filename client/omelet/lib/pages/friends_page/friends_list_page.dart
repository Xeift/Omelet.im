//TODO:好友列表的頁面
import 'package:flutter/material.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/models/message_data.dart';


class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  State<FriendsListPage> createState() => _MessagePageState();
}

class _MessagePageState extends State<FriendsListPage> {
  late final MessageData messageData;


  @override
  Widget build(BuildContext context) {
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      // onTap(){
        //TODO:按下好友後可以進到你們的聊天室
      // },
      child: ListView(
        // leading:Avatar.small(url: messageData.profilePicture),//好友的頭像
        // title:Text() //好友的名稱
      ),
    );
  }
}