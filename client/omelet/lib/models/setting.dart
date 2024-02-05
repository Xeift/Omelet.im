import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting {
  final String title;
  final String route;
  final IconData icon;

  Setting({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<Setting> settings = [
  Setting(
    title: 'Setting ',
    route: '/',
    icon: Icons.settings,
  ),
  Setting(
    title: 'Statements',
    route: '/',
    icon: CupertinoIcons.doc_fill,
  ),
];
