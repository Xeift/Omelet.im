import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../componets/alert/alert_msg.dart';
import 'package:omelet/api/post/reset_password_api.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);
  @override
  ForgetPageState createState() => ForgetPageState();
}

class ForgetPageState extends State<ForgetPage> {
  late String _userForgetEmail = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController forgetEmailController;

  @override
  void initState() {
    super.initState();
    forgetEmailController = TextEditingController();
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
      controller: forgetEmailController,
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
            // 忘記密碼邏輯
            _userForgetEmail = forgetEmailController.text;

            final res = await resetPasswordSendMailAPI(_userForgetEmail);
            final statusCode = res.statusCode;
            final resBody = jsonDecode(res.body);

            print('[forget_page.dart] API 回應內容：$resBody');

            if (!context.mounted) {
              return;
            }

            const storage = FlutterSecureStorage();

            switch (statusCode) {
              case 200:
                await storage.write(key: 'message', value: 'email 已成功寄出');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, 'Email 已成功寄出');
                });
                break;
              case 401:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  loginErrorMsg(context, 'Email 信箱不存在，請先註冊');
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
}
