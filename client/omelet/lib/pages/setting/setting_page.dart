// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:omelet/componets/button/on_update_pfp_btn_pressed.dart';
import 'package:omelet/models/setting.dart';
import 'package:omelet/pages/login_signup/loading_page.dart';
import 'package:omelet/storage/safe_config_store.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/componets/setting/avatar_card.dart';
import 'package:omelet/componets/setting/setting_title.dart';
import 'package:omelet/theme/theme_provider.dart';

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
                                                await onUpdatePfpBtnPressed();
                                                print(
                                                    '[setting_page.dart]$serverUri/pfp/${widget.ourUid}');
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          0, 255, 255, 255)),
                                              child: Text(
                                                'Select Image',
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
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          0, 255, 255, 255)),
                                              child: Text(
                                                'Delet Image',
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
                            child: Icon(
                              CupertinoIcons.ellipses_bubble_fill,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Local Language',
                              style: textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
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
                              width: 1,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Chinese Traditional',
                                child: Text('繁體中文,Chinese Traditional', overflow: TextOverflow.ellipsis,),
                                
                              ),
                              DropdownMenuItem<String>(
                                value: 'Chinese Simplified',
                                child: Text('简体中文,Chinese Simplified', overflow: TextOverflow.ellipsis,),
                              ),
                              DropdownMenuItem<String>(
                                value: 'English',
                                child: Text('English', overflow: TextOverflow.ellipsis,),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Japanese',
                                child: Text('日本語,Japanese', overflow: TextOverflow.ellipsis,),
                              ),
                              DropdownMenuItem<String>(
                                value: 'French',
                                child: Text('français,French', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'German',
                                child: Text('Deutsch,German', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Spanish',
                                child: Text('Español,Spanish', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Croatia',
                                child: Text('Hrvatski,Croatia', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Italian',
                                child: Text('Italiano,Italian', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Lithuania',
                                child: Text('lietuvių kalba,Lithuania', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Ukrainian',
                                child: Text('українська мова,Ukrainian', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Hungary',
                                child: Text('Magyar,Hungary', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Korean',
                                child: Text('한국어,Korean', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Vietnamese',
                                child: Text('Việt Ngữ,Vietnamese', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Thai',
                                child: Text('ภาษาไทย,Thai', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Indonesia',
                                child: Text('Bahasa Indonesia,Indonesia', overflow: TextOverflow.ellipsis),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Russian',
                                child: Text('русский язык,Russian', overflow: TextOverflow.ellipsis),
                              ),
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
                            child: Text('登出'),
                          ),
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
