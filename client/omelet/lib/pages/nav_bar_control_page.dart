import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/pages/friends_page/friends_list_page.dart';
import 'package:omelet/pages/notification_page/notification_page.dart';
import 'package:omelet/pages/setting/setting_page.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:http/http.dart' as http;

import '../theme/theme_constants.dart';
import 'message_list_page.dart';
// import '../pages/notification_page.dart';

class NavBarControlPage extends StatefulWidget {
  const NavBarControlPage({Key? key}) : super(key: key);

  @override
  State<NavBarControlPage> createState() => _NavBarControlPageState();
}

class _NavBarControlPageState extends State<NavBarControlPage> {
  final ValueNotifier<int> pageIndex = ValueNotifier(1);

  final List<Widget> pages = const [
    NotificationPage(),
    MessagePage(),
    FriendsListPage(),
  ];
  final List<String> title = const ['Notification', 'Message', 'Friends'];

  final String imgUrl = '$serverUri/pfp/$ourUid.png';

  late Future<bool> _urlValidFuture;

  Future<bool> isValidUrl(String url) async {
    if (url.isEmpty) return false; // 確保網址不是空的

    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200; // 如果狀態碼是 200，則視為有效的 URL
    } catch (e) {
      return false; // 發生任何異常時都視為無效的 URL
    }
  }

  @override
  void initState() {
    super.initState();
    _urlValidFuture = isValidUrl(imgUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        // 設定所需的高度
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              title: ValueListenableBuilder<int>(
                valueListenable: pageIndex,
                builder: (context, value, child) {
                  return Center(
                    child: Text(title[value]),
                  );
                },
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
              leading: FutureBuilder<bool>(
                future: _urlValidFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // 加載指示器，當url驗證中
                  } else if (snapshot.hasError || !snapshot.data!) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16.0), // 在leading左侧添加空白
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 55,
                      ),
                    ); // 換成使用者頭像
                  } else {
                    return Avatar.small(url: imgUrl); // 如果是有效的 URL，顯示圖片
                  }
                },
              ),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              centerTitle: true, // 讓標題居中
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: BottonNavbar(
        onItemSelected: (index) {
          setState(() {
            pageIndex.value = index;
          });
        },
      ),
    );
  }
}

class BottonNavbar extends StatefulWidget {
  const BottonNavbar({Key? key, required this.onItemSelected})
      : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  State<BottonNavbar> createState() => _BottonNavbarState();
}

class _BottonNavbarState extends State<BottonNavbar> {
  var selectedIndex = 1;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 获取当前上下文中的主题

    return SafeArea(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor, // 应用底部导航栏的背景颜色
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor, // 阴影颜色
              blurRadius: 5, // 模糊半径
              offset: const Offset(0, -3), // 阴影偏移量，使其向上
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
                index: 0,
                label: 'Notifications',
                icon: Icons.notifications,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected),
            NavBarItem(
                index: 1,
                label: '   Message   ',
                icon: Icons.message,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected),
            NavBarItem(
                index: 2,
                label: '     Friends    ',
                icon: Icons.pets,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected),
          ],
        ),
      ),
    );
  }
}

//navbar bottom
class NavBarItem extends StatelessWidget {
  const NavBarItem(
      {Key? key,
      required this.label,
      required this.icon,
      required this.index,
      required this.onTap,
      this.isSelected = false})
      : super(key: key);

  final ValueChanged<int> onTap;
  final int index;
  final bool isSelected;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(label,
                style: isSelected
                    ? const TextStyle(fontSize: 11, color: AppColors.secondary)
                    : const TextStyle(
                        fontSize: 11,
                      )),
          ],
        ),
      ),
    );
  }
}
