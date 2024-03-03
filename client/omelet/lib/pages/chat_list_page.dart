import 'package:flutter/material.dart';

import '../pages/setting/setting_page.dart';
import '../componets/Screen/home_page_botton_navbar.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingPage()),
              );
            },
          ),
        ],
        leading: const Icon(Icons.account_circle),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0).withAlpha(30),
      ),
      body:const SafeArea(
        child: Stack(
          fit: StackFit.expand,
        ),
      ),
      bottomNavigationBar: const BottonNavbar(),
    );
  }
}