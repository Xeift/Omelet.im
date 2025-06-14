import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppColors {
  static const accent = Color(0xFFD6755B);
  static const secondary = Color(0xFF3B76F6);
  static const cardLight = Color(0xFFF9FAFE);
  static const cardDark = Color(0xFF303334);
  static const textDark = Colors.black;
  static const textLigth = Color(0xFFF5F5F5);
  static const borderColorLight = Color.fromARGB(255, 0, 0, 0);
  static const borderColorDark = Colors.red;
}

ThemeData get lightMode => ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
          surface: Colors.white,
          primary: Color.fromARGB(255, 94, 94, 94),
          secondary: Color.fromARGB(255, 0, 0, 0)),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
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
      shadowColor: const Color.fromARGB(255, 238, 236, 236).withOpacity(0.3),
      highlightColor: AppColors.borderColorLight,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        headlineMedium: TextStyle(color: Color.fromARGB(0, 255, 255, 255)),
        titleLarge:
            TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 40),
        titleSmall: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ).apply(
        bodyColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );

ThemeData get darkMode => ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
          surface: Color.fromARGB(255, 16, 16, 16),
          primary: Color.fromARGB(255, 203, 203, 203),
          secondary: Color.fromARGB(255, 253, 253, 253)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
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
      shadowColor: const Color.fromARGB(255, 146, 146, 146).withOpacity(0.3),
      highlightColor: const Color.fromARGB(255, 255, 255, 255),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Color.fromARGB(0, 255, 255, 255)),
        titleLarge: TextStyle(color: Colors.white, fontSize: 40),
        titleSmall: TextStyle(color: Colors.white),
      ).apply(
        bodyColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
