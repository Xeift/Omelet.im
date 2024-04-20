// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omelet/componets/button/on_update_pfp_btn_pressed.dart';
import 'package:omelet/models/setting.dart';
import 'package:omelet/pages/login_signup/loading_page.dart';
import 'package:omelet/storage/safe_config_store.dart';
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
  SafeConfigStore safeConfigStore = SafeConfigStore();
  late String translateLangunage;

  @override
  void initState() {
    super.initState();
    _initializeTranslateLanguage();
  }

  Future<void> _initializeTranslateLanguage() async {
    translateLangunage =
        await safeConfigStore.getTranslationDestLang(widget.ourUid);
    print('[setting_page.dart]translateLanuage:$translateLangunage');
  }

  Future<void> _signOut() async {
    await deletCurrentActiveAccount();
    print('登出');
    if (mounted) {
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoadingPage()),
        (route) => false,
      );
    }
  }

  Future<void> _updateTranslateLanguage(String newValue) async {
    await safeConfigStore.setTranslationDestLang(widget.ourUid, newValue);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    TextTheme textTheme = Theme.of(context).textTheme;
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder<void>(
        future: _initializeTranslateLanguage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Color.fromARGB(255, 2, 2, 2),
                valueColor:
                    AlwaysStoppedAnimation(Color.fromARGB(255, 243, 128, 33)),
              ), 
            );
          } else if (snapshot.hasError) {
            // 如果加載過程中出現錯誤，則顯示錯誤信息
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
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
                                                      Color.fromARGB(
                                                          0, 255, 255, 255)),
                                              child: Text(
                                                '選擇圖片',
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
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
                                                      Color.fromARGB(
                                                          0, 255, 255, 255)),
                                              child: Text(
                                                '刪除照片',
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
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
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '翻譯語言設定',
                            style: textTheme.titleSmall,
                          ),
                          const Spacer(),
                          DropdownButton(
                            value: translateLangunage,
                            onChanged: (String? newValue) async {
                              setState(() {
                                translateLangunage = newValue!;
                              });
                              await _updateTranslateLanguage(newValue!);
                            },
                            icon: Icon(CupertinoIcons.chevron_compact_down),
                            underline: Container(
                              height: 2,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            items: const [
                              DropdownMenuItem<String>(
                                  value: 'Chinese', child: Text('中文,Chinese')),
                              DropdownMenuItem<String>(
                                  value: 'English', child: Text('English')),
                              DropdownMenuItem<String>(
                                  value: 'Japanese',
                                  child: Text('日本語,Japanese')),
                              DropdownMenuItem<String>(
                                  value: 'French',
                                  child: Text('français,French')),
                              DropdownMenuItem<String>(
                                  value: 'German',
                                  child: Text('Deutsch,German')),
                              DropdownMenuItem<String>(
                                  value: 'Spanish',
                                  child: Text('Español,Spanish')),
                              DropdownMenuItem<String>(
                                  value: 'Croatia',
                                  child: Text('Hrvatski,Croatia')),
                              DropdownMenuItem<String>(
                                  value: 'Italian',
                                  child: Text('Italiano,Italian')),
                              DropdownMenuItem<String>(
                                  value: 'Lithuania',
                                  child: Text('lietuvių kalba,Lithuania')),
                              DropdownMenuItem<String>(
                                  value: 'Ukrainian',
                                  child: Text('українська мова,Ukrainian')),
                              DropdownMenuItem<String>(
                                  value: 'Hungary',
                                  child: Text('Magyar,Hungary')),
                              DropdownMenuItem<String>(
                                  value: 'Korean', child: Text('한국어,Korean')),
                              DropdownMenuItem<String>(
                                  value: 'Vietnamese',
                                  child: Text('Việt Ngữ,Vietnamese')),
                              DropdownMenuItem<String>(
                                  value: 'Thai', child: Text('ภาษาไทย,Thai')),
                              DropdownMenuItem<String>(
                                  value: 'Indonesia',
                                  child: Text('Bahasa Indonesia,Indonesia')),
                              DropdownMenuItem<String>(
                                  value: 'Russian',
                                  child: Text('русский язык,Russian')),
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
        });
  }
}
