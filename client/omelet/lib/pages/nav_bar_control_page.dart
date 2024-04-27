import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:omelet/componets/message/avatar_user.dart';
import 'package:omelet/pages/friends_page/friends_list_page.dart';
import 'package:omelet/pages/notification_page/notification_page.dart';
import 'package:omelet/pages/setting/setting_page.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/theme/theme_constants.dart';
import 'package:omelet/pages/message_list_page.dart';
// import '../pages/notification_page.dart';

class NavBarControlPage extends StatefulWidget {
  const NavBarControlPage({Key? key, required this.ourUid}) : super(key: key);
  final String ourUid;
  @override
  State<NavBarControlPage> createState() => _NavBarControlPageState();
}

class _NavBarControlPageState extends State<NavBarControlPage> {
  final ValueNotifier<int> pageIndex = ValueNotifier(1);
  late List<Widget> pages;
  final List<String> title = const ['Notifications', 'Messages', 'Friends'];

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
    pages = [
      NotificationPage(ourUid: widget.ourUid),
      MessagePage(ourUid: widget.ourUid),
      FriendsListPage(ourUid: widget.ourUid),
    ];
    _urlValidFuture = isValidUrl('$serverUri/pfp/${widget.ourUid}.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        // 設定所需的高度
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.only(top: 15, right: 15, left: 15),
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
                                builder: (_) =>
                                    SettingPage(ourUid: widget.ourUid)),
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.data!) {
                      return IconButton(
                        icon:
                            const Icon(Icons.account_circle_outlined, size: 55),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    SettingPage(ourUid: widget.ourUid)),
                          );
                        },
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SettingPage(ourUid: widget.ourUid)),
                          );
                        },
                        child: AvatarUser.small(
                          url: '$serverUri/pfp/${widget.ourUid}.png',
                        ),
                      ); // 如果是有效的 URL，显示图片
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
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 5,
              offset: const Offset(0, -3),
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
                label: '   Messages   ',
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
