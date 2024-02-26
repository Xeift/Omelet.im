// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:omelet/models/setting.dart';
import 'package:provider/provider.dart';

import '../../componets/setting/avatarcard.dart';
import '../../componets/setting/setting_title.dart';
import '../../theme/theme_provider.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override


  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AvatarCard(),
              const SizedBox(height: 20,),
              const Divider(),
              const SizedBox(height: 10,),
              Column(
                children: List.generate(
                  settings.length, 
                  (index) => SettingTitle(setting: settings[index]),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text(
                  'Dark theme',
                  style: textTheme.titleSmall?.copyWith(
                    color:Theme.of(context).colorScheme.primary,
                  ), // 使用 subtitle1 而不是 titleSmall
                ),
                 onTap: (){
                  Provider.of<ThemeProvier>(context,listen: false).toggleTheme();
                 },
              ),
            ],
          ),
        ),
      ),
    );
  }
}