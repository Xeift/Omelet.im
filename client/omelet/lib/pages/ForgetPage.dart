import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omelet/api/all_login_api.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key, required this.t}) : super(key: key);
  final String t;
  @override
   _ForgetPageState createState() =>  _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage>{
  late String _ForgetEmail = '';
  bool _clicked_Textfield = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var forgetEamilcontroller;
  @override
  void initState() {
    super.initState();
    forgetEamilcontroller = TextEditingController();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:const Icon(Icons.arrow_back_ios),
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
            const SizedBox(height: 30),
            buildForget_emailTextField(),
            const SizedBox(height:30),
            buildForget_submitButton(),
          
          ],
        ),
      ),
    );
  }

  Widget buildForget_title(){
    return const Padding(
      padding: EdgeInsets.all(8),
      child:Text(
          'Sign Up',
          style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget buildForget_emailTextField(){
  return TextField(
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Email Address',
    ),
    controller: forgetEamilcontroller,
  );
  }
  // ignore: non_constant_identifier_names
  Widget buildForget_submitButton(){
    return Align(
      child:SizedBox(
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
          onPressed: () async{
            _ForgetEmail = forgetEamilcontroller.text;
            final forgetemailres = await forgetemailAPI(_ForgetEmail);
            final statusCode = forgetemailres.statusCode;
            final resBody = jsonDecode(forgetemailres.body);

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

