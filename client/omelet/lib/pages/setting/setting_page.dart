import 'package:flutter/material.dart';

import './avatarcard.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const AvatarCard(),
             const SizedBox(height: 20,),
             const Divider(),
             const SizedBox(height: 10,),
             Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 5,),
                const Text("personal")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
