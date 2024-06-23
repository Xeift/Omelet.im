import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:omelet/pages/login_signup/loading_page.dart';
import 'package:omelet/theme/theme_constants.dart';
import 'package:omelet/theme/theme_provider.dart';

void main() {
  debugPaintSizeEnabled = false; // 顯示組件的邊界
  debugPaintBaselinesEnabled = false; // 顯示組件的基線
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
      title: 'Omelet.im',
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(),
      },
    );
  }
}
