// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omelet/componets/button/on_update_pfp_btn_pressed.dart';
import 'package:omelet/models/setting.dart';
import 'package:provider/provider.dart';

import '../../componets/setting/avatar_card.dart';
import '../../componets/setting/setting_title.dart';
import '../../theme/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    TextTheme textTheme = Theme.of(context).textTheme;
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                //點擊使用者欄，可變更用戶照片
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoPopupSurface(
                          child: SizedBox(
                              height: 200,
                              width: screenWidth,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        onUpdatePfpBtnPressed();
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(0, 255, 255, 255)),
                                      child: Text(
                                        '選擇圖片',
                                        style: textTheme.titleSmall?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    width: 300,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        print('[setting_page]刪除圖片');
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(0, 255, 255, 255)),
                                      child: Text(
                                        '刪除照片',
                                        style: textTheme.titleSmall?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )), // 欲顯示於該視窗的內容
                        );
                      });
                },
                child: AvatarCard(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Provider.of<ThemeProvier>(context, listen: false)
                      .toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
