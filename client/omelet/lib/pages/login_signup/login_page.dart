import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omelet/developer/test_ping_page.dart';

import 'package:omelet/pages/login_signup/forget_page.dart';
import 'package:omelet/theme/theme_constants.dart';
import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/componets/alert/alert_msg.dart';
import 'package:omelet/pages/nav_bar_control_page.dart';
import 'package:omelet/pages/login_signup/sign_up_page.dart';
import 'package:omelet/api/post/login_api.dart';
import 'package:omelet/signal_protocol/generate_and_store_key.dart';
import 'package:omelet/pages/login_signup/loading_page.dart'
    show LoadingPageState;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late String _userEmail = '', _userPassword = '';
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  late TextEditingController emailTextFieldController;
  late TextEditingController passwordTextFieldController;

  String ourUid = '';

  @override
  void initState() {
    //初始化
    super.initState();
    emailTextFieldController = TextEditingController();
    passwordTextFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      darkTheme: darkMode,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: kToolbarHeight),
              const SizedBox(height: 50),
              buildTitle(),
              const SizedBox(height: 30),
              buildEmailTextField(),
              const SizedBox(height: 30),
              buildPasswordTextField(),
              buildForgetPassword(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLoginButton(),
                  const SizedBox(width: 30),
                  buildSignupPageButton(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    //Login字樣
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        'Login',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget buildPasswordTextField() {
    // 密碼輸入框
    return TextFormField(
      obscureText: _isObscure,
      controller: passwordTextFieldController,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      decoration: InputDecoration(
        // 隱藏密碼按鈕
        labelText: 'Password',
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 113, 113, 113)),
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            // 隱藏密碼按鈕 onpress event
            setState(() {
              _isObscure = !_isObscure;
              _eyeColor = (_isObscure
                  ? Colors.grey
                  : Theme.of(context).iconTheme.color)!;
            });
          },
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    // Email輸入框
    return TextFormField(
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      decoration: InputDecoration(
        labelText: 'Email Address',
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 113, 113, 113)),
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      // style: TextStyle(color:Theme.of(context).colorScheme.secondary),
      controller: emailTextFieldController,
    );
  }

  Widget buildForgetPassword() {
    // 忘記密碼
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ForgetPage()));
          },
          child: const Text(
            'Forget password',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void nextPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => NavBarControlPage(ourUid: ourUid)),
        (route) => false);
  }

  Widget buildLoginButton() {
    // 登入按鈕，按下可以送出表單
    return Align(
      child: SizedBox(
        height: 50,
        width: 150,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.titleLarge,
          ),
          onPressed: () async {
            // 登入邏輯
            _userEmail = emailTextFieldController.text;
            _userPassword = passwordTextFieldController.text;

            if (_userEmail == 'testping' && _userPassword == 'pingtest') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TestPingPage()));
            }

            final res = await loginApi(_userEmail, _userPassword);
            print(
                '[login_page.dart deBug]:userEmail:$_userEmail,_userPassword:$_userPassword');
            final statusCode = res.statusCode;
            print('[login_page.dart deBug]res report:$statusCode');
            print('[home_page.dart] API 回應內容：${res.body}');

            final resBody = jsonDecode(res.body);

            if (!context.mounted) {
              return;
            }

            const storage = FlutterSecureStorage();
            switch (statusCode) {
              case 200:
                await changeCurrentActiveAccount(resBody['data']['uid']);

                ourUid = await loadCurrentActiveAccount();

                // 將使用者資訊寫入本地儲存空間
                await storage.write(
                    key: '${ourUid}_token', value: resBody['token']);
                await storage.write(
                    key: '${ourUid}_uid', value: resBody['data']['uid']);
                await storage.write(
                    key: '${ourUid}_username',
                    value: resBody['data']['username']);
                await storage.write(
                    key: '${ourUid}_email', value: resBody['data']['email']);

                // 產生並儲存 Signal Protocol 金鑰
                await generateAndStoreKey();

                await LoadingPageState().initSocket();

                print('登入後的uid:{$ourUid}');

                print(
                    '[login_page] 目前啟用帳號為：${await loadCurrentActiveAccount()}');

                print('[login_page] 目前所有內容：${await storage.readAll()}');
                print(
                    '[login_page] 目前所有 key：${(await storage.readAll()).keys}');
                print('準備跳轉至使用者介面');

                nextPage();
                break;
              case 401:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, '帳號密碼錯誤');
                });
                break;
              case 422:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, '請輸入帳號密碼');
                });
                break;
              case 429:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, '請稍候再重新輸入');
                });
                break;
              case 500:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, '伺服器端錯誤');
                });
                break;
              default:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, '發生未知錯誤');
                });
                break;
            }
          },
        ),
      ),
    );
  }

  Widget buildSignupPageButton() {
    return Align(
      child: SizedBox(
        height: 50,
        width: 150,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            minimumSize: MaterialStateProperty.all(const Size(100, 50)),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.grey, width: 1)),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SignUpPage()));
          },
          autofocus: true,
          child: Text(
            'Sign Up',
            style: Theme.of(context).primaryTextTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
