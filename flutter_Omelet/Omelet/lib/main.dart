import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
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
  late String _email ='',_password ='';
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _EmailAutoFocus = true;
  bool _EmailFieldisEmpty = true;
  Color _eyeColor = Colors.grey;
  var emailTextFieldController,passwordTextFieldController;
  @override
  void initState() {//初始化
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
            buildEmailTextField(),
            const SizedBox(height: 30),
            buildPasswordTextField(),
            buildForgetPassword(),
            const SizedBox(height: 20),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLoingButton(),
                  const SizedBox(width: 30),
                  buildSignupButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {//Login字樣
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Loing',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget buildPasswordTextField() {//密碼輸入匡
    return TextFormField(
      obscureText: _isObscure,
      controller:passwordTextFieldController,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
              _eyeColor = (_isObscure ? Colors.grey : Theme.of(context).iconTheme.color)!;
            });
          },
        ),
      ),
    );
  }

  Widget buildEmailTextField() {//Email輸入框
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email Address'),
      validator: (v) {
        var emailReg = RegExp(r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");

    },
    // onSaved: (v) => _email = v!,
      controller:emailTextFieldController,
    );
  }

  Widget buildForgetPassword() {//忘記密碼
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            //TOGO forget pages
          },
          child: Text('Forget password'),
        ),
      ),
    );
  }

  Widget buildLoingButton() {//登入按鈕，按下可以送出表單
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
            style: Theme.of(context).primaryTextTheme!.headline6,
          ),
          onPressed: () {//連接後端API
            _email = emailTextFieldController.text;//_email字串存入_email變數
            _password = passwordTextFieldController.text;//_email字串存入_email變數
            // _password = passwordTextFieldController.text;
            print('email: $_email, password: $_password');//測試使用
          },
        ),
      ),
    );
  }

  Widget buildSignupButton() {
    return Align(
      child: SizedBox(
        height: 50,
        width: 150,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            minimumSize: MaterialStateProperty.all(const Size(100, 50)),
            side: MaterialStateProperty.all(const BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Text(
            'Sign Up',
            style: Theme.of(context).primaryTextTheme!.headline6,
          ),
          onPressed: () {
            //TOGO
          },
          autofocus: true,
        ),
      ),
    );
  }
}



