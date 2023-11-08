// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, unnecessary_string_interpolations, avoid_print, deprecated_member_use, avoid_unnecessary_containers
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omelet/pages/ForgetPage.dart';
import '../api/all_login_api.dart';
import '../componets/alert/AlertMsg.dart';
import '../pages/SignUpPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';//login animation
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omelet Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ), 
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(title: "Login"),
      },
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _Email = '', _Password = '';
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  Color _eyeColor = Colors.grey;
  var emailTextFieldController, passwordTextFieldController;
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLoingButton(), //登入button控件呼叫
                  const SizedBox(width: 30),
                  buildSignupPageButton(), //註冊button控件呼叫
                ],
              ),
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
             Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ForgetPage())
            );
          },
          child: const Text('Forget password'),
        ),
      ),
    );
  }

  Widget buildLoingButton() {
    const loginspinkit = SpinKitChasingDots(
  color: Colors.white,
  size: 50.0,
);

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
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          onPressed: () async {
            //連接後端API,登入button，pressed event，當按下它會執行下方程式
            _Email = emailTextFieldController.text; //_email字串存入_email變數
            _Password = passwordTextFieldController.text; //_email字串存入_email變數

            final res = await loginAPI(_Email, _Password);
            final statusCode = res.statusCode;
            final resBody = jsonDecode(res.body);

            print('$_Email');
            print(statusCode); // http 狀態碼
            print(resBody); // 登入 API 回應內容
            print(resBody['message']); // 取得登入 API 回應內容中的 message 內容

            if (statusCode == 200) {
              print('登入成功( •̀ ω •́ )✧');
              // 這裡要寫登入成功時的邏輯，比如提示使用者密碼錯誤
              // 所有 API 回應內容請見：Omelet.im\backend\api\login.js
            } else if (statusCode == 401) {
              // 帳號密碼錯誤
              LoginEorroMsg(context,'帳號密碼錯誤');
            } else if (statusCode == 422) {
              // 帳號密碼為空
              LoginEorroMsg(context,'請輸入帳號密碼');
            } else if (statusCode == 429) {
              // 速率限制，請求次數過多（5分鐘內超過10次）
              LoginEorroMsg(context,'請稍候在重新輸入');
            } else if (statusCode == 500) {
              // 後端其他錯誤
              LoginEorroMsg(context,'Another Eorro for server');
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
             Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SignUpPage())
            );
          },
          autofocus: true,
          child: Text(
            'Sign Up',
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ),
      ),
    );
  }

}
