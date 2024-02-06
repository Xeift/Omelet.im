import 'dart:convert';
import 'package:flutter/material.dart';

import '../../componets/alert/alert_msg.dart';
import '../../api/post/reset_password_api.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);
  @override
  ForgetPageState createState() => ForgetPageState();
}

class ForgetPageState extends State<ForgetPage> {
  late String _userForgetEmail = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController forgetEamilcontroller;

  @override
  void initState() {
    super.initState();
    forgetEamilcontroller = TextEditingController();
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
            const SizedBox(height: 30),
            buildForgetTitle(),
            const SizedBox(height: 120),
            buildForgetEmailTextField(),
            const SizedBox(height: 30),
            buildForgetSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget buildForgetTitle() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Forget Password',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget buildForgetEmailTextField() {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email Address',
      ),
      controller: forgetEamilcontroller,
    );
  }

  Widget buildForgetSubmitButton() {
    return Align(
      child: SizedBox(
        height: 50,
        width: 150,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          child: Text(
            'Submit',
            style: Theme.of(context).primaryTextTheme.titleLarge,
          ),
          onPressed: () async {
            _userForgetEmail = forgetEamilcontroller.text;
            final forgetemailres =
                await resetPasswordSendMailAPI(_userForgetEmail);
            final statusCode = forgetemailres.statusCode;
            final resBody = jsonDecode(forgetemailres.body);
            if (!context.mounted) {
              return;
            } else {
              if (statusCode == 200) {
                loginErrorMsg(context, 'email 已成功寄出');
              } else if (statusCode == 401) {
                loginErrorMsg(context, 'Eamil 不存在，請先註冊');
              } else if (statusCode == 500) {
                loginErrorMsg(context, 'Eorror server');
              }
            }
            print(_userForgetEmail);
            print(statusCode); // http 狀態碼
            print(resBody); //
            print(resBody['message']); // 取得登入 API 回應內容中的 message 內容
            //build await function after complete date transform
          },
        ),
      ),
    );
  }
}
