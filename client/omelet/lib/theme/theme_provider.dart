// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import '../theme/theme_constants.dart';

class ThemeProvier with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
void toggleTheme() {
    themeData = _themeData == lightMode ? darkMode : lightMode;
  }
}

