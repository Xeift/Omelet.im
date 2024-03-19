import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:omelet/pages/nav_bar_control_page.dart';
import 'package:omelet/pages/login_signup/loading_page.dart';
import './theme/theme_constants.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';

//import 'signal_protocol/generate_and_store_key.dart';
final hintMsgKey = GlobalKey();
void main() {
  debugPaintSizeEnabled = false; // 顯示組件的邊界
  debugPaintBaselinesEnabled = false; // 顯示組件的基線
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omelet Login Page',
      theme: Provider.of<ThemeProvier>(context).themeData,
      darkTheme: darkMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(),
        'Home': (BuildContext context) => const NavBarControlPage(),
      },
    );
  }
}
