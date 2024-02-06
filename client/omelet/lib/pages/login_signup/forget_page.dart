// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, unnecessary_string_interpolations, avoid_print, duplicate_ignore, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/componets/alert/alert_msg.dart';

import './../../api/post/reset_password_api.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);
  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  late String _ForgetEmail = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var forgetEamilcontroller;

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
            buildForget_title(),
            const SizedBox(height: 120),
            buildForget_emailTextField(),
            const SizedBox(height: 30),
            buildForget_submitButton(),
          ],
        ),
      ),
    );
  }

  Widget buildForget_title() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Forget Password',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget buildForget_emailTextField() {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email Address',
      ),
      controller: forgetEamilcontroller,
    );
  }

  Widget buildForget_submitButton() {
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
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          onPressed: () async {
            _ForgetEmail = forgetEamilcontroller.text;
            final forgetemailres = await resetPasswordSendMailAPI(_ForgetEmail);
            final statusCode = forgetemailres.statusCode;
            final resBody = jsonDecode(forgetemailres.body);
            if (statusCode == 200) {
              loginErrorMsg(context, 'email 已成功寄出');
            } else if (statusCode == 401) {
              loginErrorMsg(context, 'Eamil 不存在，請先註冊');
            } else if (statusCode == 500) {
              loginErrorMsg(context, 'Eorror server');
            }

            print('$_ForgetEmail');
            print(statusCode); // http 狀態碼
            print(resBody); //
            print(resBody['message']); // 取得登入 API 回應內容中的 message 內容
            //build await function after complet date transform
          },
        ),
      ),
    );
  }
}
