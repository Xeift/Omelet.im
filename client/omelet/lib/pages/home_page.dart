import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/pages/login_signup/forget_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../componets/alert/alert_msg.dart';
import '../pages/chat_list_page.dart';
import '../pages/login_signup/sign_up_page.dart';

import 'package:omelet/api/post/login_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String _userEmail = '', _userPassword = '';
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  late TextEditingController emailTextFieldController;
  late TextEditingController passwordTextFieldController;

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
              buildEmailTextField(), //Email輸入框控件呼叫
              const SizedBox(height: 30),
              buildPasswordTextField(), //Password輸入框控件呼叫
              buildForgetPassword(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLoginButton(), //登入button控件呼叫
                  const SizedBox(width: 30),
                  buildSignupPageButton(), //註冊button控件呼叫
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    //Login字樣
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget buildPasswordTextField() {
    //密碼輸入匡
    return TextFormField(
      obscureText: _isObscure,
      controller: passwordTextFieldController,
      decoration: InputDecoration(
        //密碼遮蔽button
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            //密碼遮蔽button，onpress event
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
    //Email輸入框
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email Address'),
      controller: emailTextFieldController,
    );
  }

  Widget buildForgetPassword() {
    //忘記密碼
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ForgetPage()));
          },
          child: const Text('Forget password'),
        ),
      ),
    );
  }

  void nextPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const ChatListPage()),
        (route) => false);
  }

  Widget buildLoginButton() {
    //登入按鈕，按下可以送出表單
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

            final res = await loginApi(_userEmail, _userPassword);
            final statusCode = res.statusCode;
            final resBody = jsonDecode(res.body);

            print('[home_page.dart] API 回應內容：$resBody');

            if (!context.mounted) {
              return;
            }

            const storage = FlutterSecureStorage();
            switch (statusCode) {
              case 200:
                await storage.write(key: 'token', value: resBody['token']);
                await storage.write(key: 'uid', value: resBody['data']['uid']);
                await storage.write(
                    key: 'username', value: resBody['data']['username']);
                await storage.write(
                    key: 'email', value: resBody['data']['email']);
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
