import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/pages/login_signup/forget_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../componets/alert/alert_msg.dart';
import '../pages/chat_list_page.dart';
import '../pages/login_signup/sign_up_page.dart';

import './../api/post/login_api.dart';

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
    return Scaffold(
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
                buildLoingButton(), //登入button控件呼叫
                const SizedBox(width: 30),
                buildSignupPageButton(), //註冊button控件呼叫
              ],
            ),
          ],
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
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ChatListPage()));
  }

  Widget buildLoingButton() {
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
            //連接後端API,登入button，pressed event，當按下它會執行下方程式
            _userEmail = emailTextFieldController.text; //_email字串存入_email變數
            _userPassword =
                passwordTextFieldController.text; //_email字串存入_email變數
            print(_userPassword);
            final res = await loginAPI(_userEmail, _userPassword);
            final statusCode = res.statusCode;
            final resBody = jsonDecode(res.body);
            print(_userEmail);
            print(statusCode); // http 狀態碼
            print(resBody); // 登入 API 回應內容
            print(resBody['message']);

            if (!context.mounted) {
              return;
            }
            if (statusCode == 200) {
              const storage = FlutterSecureStorage();
              await storage.write(key: 'token', value: resBody['token']);
              await storage.write(key: 'uid', value: resBody['data']['uid']);
              await storage.write(
                  key: 'username', value: resBody['data']['username']);
              await storage.write(
                  key: 'email', value: resBody['data']['email']);

              print('[main.dart] 目前儲存空間所有內容：${await storage.readAll()}');
              nextPage();
            } else if (statusCode == 401) {
              // 帳號密碼錯誤
              ('帳號密碼錯誤');
            } else if (statusCode == 422) {
              // 帳號密碼為空
              loginErrorMsg(context, '請輸入帳號密碼');
            } else if (statusCode == 429) {
              // 速率限制，請求次數過多（5分鐘內超過10次）
              loginErrorMsg(context, '請稍候在重新輸入');
            } else if (statusCode == 500) {
              // 後端其他錯誤
              loginErrorMsg(context, 'Another Eorro for server');
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
