// import 'dart:convert';

import 'package:flutter/material.dart';

import '../../componets/alert/alert_msg.dart';

import './../../api/post/signup_api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  Color _eyeColor = Colors.grey;
  bool _isObscure = true;
  late String _signUpEamil = '', _singUpPassword = '', _signUpName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController emailSignUpTextFieldController,
      passwordSignUpTextFieldController,
      nameSignUpTextFieldController;

  @override
  void initState() {
    super.initState();
    emailSignUpTextFieldController = TextEditingController();
    passwordSignUpTextFieldController = TextEditingController();
    nameSignUpTextFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              buildSignUpEamilTextField(),
              const SizedBox(height: 30),
              buildSignUpNameTextField(),
              const SizedBox(height: 30),
              buildSignUpPasswordTextField(),
              const SizedBox(height: 30),
              buildSignUpButton(),
            ],
          )),
    );
  }

  Widget buildSignUpEamilTextField() {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email Address',
      ),
      controller: emailSignUpTextFieldController,
    );
  }

  Widget buildSignUpNameTextField() {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'User Name',
      ),
      controller: nameSignUpTextFieldController,
    );
  }

  Widget buildSignUpPasswordTextField() {
    // 密碼輸入框
    return TextFormField(
      obscureText: _isObscure,
      controller: passwordSignUpTextFieldController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        // 隱藏密碼按鈕
        labelText: 'Password',
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

  Widget buildTitle() {
    // Login 字樣
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Sign Up',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget buildSignUpButton() {
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
          onPressed: () async {
            _signUpEamil = emailSignUpTextFieldController.text;
            _singUpPassword = passwordSignUpTextFieldController.text;
            _signUpName = nameSignUpTextFieldController.text;

            final res = await signUpSendMailApi(
                _signUpEamil, _signUpName, _singUpPassword);
            final statusCode = res.statusCode;

            print('[sign_up_page.dart] ${res.body}');

            if (!context.mounted) {
              return;
            }

            switch (statusCode) {
              case 200:
                loginErrorMsg(context, '已寄送驗證 Email，請查看信箱');
                break;
              case 409:
                loginErrorMsg(context, '此 Email 已被使用，請登入');
                break;
              case 422:
                loginErrorMsg(context, '請輸入註冊資訊');
                break;
              case 429:
                loginErrorMsg(context, '請稍候再重新輸入');
                break;
              case 500:
                loginErrorMsg(context, '伺服器預期外錯誤');
                break;
              default:
                loginErrorMsg(context, '未知錯誤');
            }
          },
          autofocus: true,
          child: Text(
            'Submit',
            style: Theme.of(context).primaryTextTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
