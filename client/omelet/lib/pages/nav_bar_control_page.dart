import 'package:flutter/material.dart';
import 'package:omelet/pages/notification_page.dart';

import '../pages/setting/setting_page.dart';
import '../theme/theme_constants.dart';
import '../pages/message_page.dart';
// import '../pages/notification_page.dart';

class NavBarControlPage extends StatefulWidget {
  const NavBarControlPage({Key? key}) : super(key: key);

  @override
  State<NavBarControlPage> createState() => _NavBarControlPageState();
}

class _NavBarControlPageState extends State<NavBarControlPage> {
  final ValueNotifier<int> pageIndex = ValueNotifier(1);

  final List<Widget> pages = const [
    NotificationPgae(),
    MessagePage(),
    SettingPage(),
  ];
  final List<String> title = const [
    'Notification',
    'Message',
    'Setting'
  ];

  @override
  Widget build(BuildContext context) {
    pageIndex.addListener(() {
      print(pageIndex.value);
    });
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (context, value, child) {
              return Text(title[value]);
            },
          ),
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
          backgroundColor:const Color.fromARGB(255, 0, 0, 0).withAlpha(30),
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
  const BottonNavbar({Key? key, required this.onItemSelected}) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  State<BottonNavbar> createState() => _BottonNavbarState();
}

class _BottonNavbarState extends State<BottonNavbar> {
  var selectedIndex = 1;
  
  void handleItemSelected(int index){
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
              label: '     Setting    ', 
              icon: Icons.settings, 
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
  const NavBarItem({Key? key, required this.label, required this.icon, required this.index, required this.onTap,this.isSelected = false}) : super(key: key);

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
            const SizedBox(height: 7,),
            Text(
              label,
              style: isSelected 
              ? const TextStyle(fontSize: 11,color:AppColors.secondary)
              : const TextStyle(fontSize: 11,)),
          ],
        ),
      ),
    );
  }
}