// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omelet/componets/button/on_update_pfp_btn_pressed.dart';
import 'package:omelet/models/setting.dart';
import 'package:omelet/pages/login_signup/loading_page.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:provider/provider.dart';

import '../../componets/setting/avatar_card.dart';
import '../../componets/setting/setting_title.dart';
import '../../theme/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required this.ourUid}) : super(key: key);
  final String ourUid;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final LoadingPageState loadingPageState = LoadingPageState();
  List<String> translateType = ['中文','English'];

  Future<void> _signOut() async {
    await deletCurrentActiveAccount();
    // await loadingPageState.deleteAll();
    //   const storage = FlutterSecureStorage();
    //  await storage.deleteAll();
    print('登出');
    // await loadingPageState.initSocket();
    if (mounted) {
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoadingPage()),
        (route) => false,
      );
    }
  }

  String translateLangunage = 'Chinese';
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
                child: AvatarCard(
                  ourUid: widget.ourUid,
                ),
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
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 190, 190, 190),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(CupertinoIcons.ellipses_bubble_fill,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '翻譯語言設定',
                    style: textTheme.titleSmall,
                  ),
                  const Spacer(),
                  DropdownButton(
                    value: translateLangunage,
                    onChanged: (String? newValue) {
                      setState(() {
                        translateLangunage = newValue!;
                      });
                      
                    },
                    icon: Icon(CupertinoIcons.chevron_compact_down),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Chinese',
                        child: Text('中文')),
                        DropdownMenuItem<String>(
                        value: 'English',
                        child: Text('English')),
                        DropdownMenuItem<String>(
                        value: 'Japanese',
                        child: Text('にほんご')),

                    ],
                    
                    )
                ],
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
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _signOut();
                    },
                    // style: ButtonStyle(
                    //     backgroundColor: Theme.of(context)
                    //         .elevatedButtonTheme
                    //         .style
                    //         ?.backgroundColor),
                    child: Text('登出'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
