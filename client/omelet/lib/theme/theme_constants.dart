import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey.shade300,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
        primary: Colors.grey.shade800,
        
  ),
  iconTheme: const IconThemeData(
    color: Color.fromARGB(255, 251, 251, 251), // 设置图标的颜色为白色
  ),
  // 其他主題設定
);
