import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppColors {
  static const accent = Color(0xFFD6755B);
  static const secondary = Color(0xFF3B76F6);
  static const cardLight = Color(0xFFF9FAFE);
  static const cardDark = Color(0xFF303334);
  static const textDark = Colors.black; // 修改为合适的颜色值
  
  static const textLigth = Color(0xFFF5F5F5);// 修改为合适的颜色值
}

ThemeData get lightMode => ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey,
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: AppColors.textDark,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  shadowColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3)
);

ThemeData get darkMode => ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 16, 16, 16),
    primary: Colors.grey,
  ),
  appBarTheme:const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
  iconTheme: const IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
  shadowColor:Color.fromARGB(255, 97, 97, 97).withOpacity(0.3)
);
