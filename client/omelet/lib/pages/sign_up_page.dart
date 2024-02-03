// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_old/all_login_api.dart';
import '../componets/alert/alert_msg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Color _eyeColor = Colors.grey;
  bool _isObscure = true;
  late String _signUpEamil = '', _singUppassword = '', _signUpName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var emailSignUpTextFieldController,
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
    //密碼輸入匡
    return TextFormField(
      obscureText: _isObscure,
      controller: passwordSignUpTextFieldController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
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

  Widget buildTitle() {
    //Login字樣
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Reset Password',
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
            _singUppassword = passwordSignUpTextFieldController.text;
            _signUpName = nameSignUpTextFieldController.text;
            final signUpres =
                await signUpAPI(_signUpEamil, _signUpName, _singUppassword);
            final signUpstateCode = signUpres.statusCode;
            final resBody = jsonDecode(signUpres.body);
            print('$_signUpEamil');
            print(signUpstateCode); // http 狀態碼
            print(resBody); // 登入 API 回應內容
            print(resBody['message']);

            if (signUpstateCode == 200) {
              print('登入成功( •̀ ω •́ )✧');
              // 這裡要寫登入成功時的邏輯，比如提示使用者密碼錯誤
              // 所有 API 回應內容請見：Omelet.im\backend\api\login.js
            } else if (signUpstateCode == 401) {
              // 帳號密碼錯誤
              LoginEorroMsg(context, 'Eamil已存在');
            } else if (signUpstateCode == 422) {
              // 帳號密碼為空
              LoginEorroMsg(context, '請輸入註冊資訊');
            } else if (signUpstateCode == 500) {
              // 後端其他錯誤
              LoginEorroMsg(context, 'Another Eorro for server');
            }
          },
          autofocus: true,
          child: Text(
            'Submit',
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ),
      ),
    );
  }
}
