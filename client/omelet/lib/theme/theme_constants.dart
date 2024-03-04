import 'package:flutter/material.dart';

abstract class AppColor{
  static const textDark = Color.fromARGB(0, 255, 255, 255);
  static const textLight = Color.fromARGB(0, 0, 0, 0);
  static const secondary = Color.fromARGB(255, 115, 213, 251);
}


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey.shade300,
    
  )
  ,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),

  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: const Color.fromARGB(255, 20, 22, 30),
    primary: Colors.grey.shade800,
  ),
  iconTheme: const IconThemeData(
    color: Color.fromARGB(255, 251, 251, 251), // 设置图标的颜色为白色
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 20, 22, 30),
  ),
);