import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './pages/home_page.dart';

import 'signal_protocol/generate_and_store_key.dart';

void main() async {
  runApp(const MyApp());
  await generateAndStoreKey();
  const storage = FlutterSecureStorage();
  print(await storage.readAll());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omelet Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Login'),
      },
    );
  }
}
