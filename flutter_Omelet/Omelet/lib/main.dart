import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  debugPaintSizeEnabled:true;
  runApp(const MyApp());

}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title:'Flutter Demo',
      theme:ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes:{
    "/":(context) => const HomePage(title: "Login"),
    });
  }
}
class HomePage extends StatefulWidget{
  const HomePage({Key? key,required this.title}):super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _email,_password;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Form(
        key : _formKey,

        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding:const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height:kToolbarHeight),
            const SizedBox(height: 50),
            buildTitle(),
            const SizedBox(height: 30),
            buildEmailTextField(),
            const SizedBox(height: 30),
            buildPasswordTextField(),
            buildForgetPassword(),
            const SizedBox(height: 20),
            Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLoingButton(),
                  const SizedBox(width: 30,),
                  buildSigninButton(),
                ],
              ),

            ),

          ],
        ),
      ),
    );
  }


  Widget buildTitle(){
    return const Padding(
      padding:EdgeInsets.all(8),
      child:Text('Loing',
      style:TextStyle(fontSize: 40),
      ),
    );
  }


  Widget buildPasswordTextField(){
    return TextFormField(
      obscureText: _isObscure,
      onSaved: (v) => _password = v!,
      validator: (v){
        if(v!.isEmpty){
          return('please enter your password');
      }
      },
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon:Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: (){
            setState(() {
              _isObscure = !_isObscure;
              _eyeColor = (_isObscure
              ?Colors.grey
              :Theme.of(context).iconTheme.color)!;

            });
          },
        )));
  }

  Widget buildEmailTextField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email Address'),
    validator: (v) {
        var emailReg = RegExp(r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(v!)){
          return 'please enter correct email address';
        }
      },

    );
  }
  Widget buildForgetPassword(){
    return Padding(
      padding:const EdgeInsets.only(top:8),
      child:Align(
        alignment: Alignment.centerRight,
        child:TextButton(
          onPressed: (){
            //TOGO forget pages
          },
          child:Text('Forget password'),
        ),
      ),
    );

  }

  Widget buildLoingButton(){
    return Align(
      child:SizedBox(
        height: 50,
        width: 140,
        child: ElevatedButton(

          style:ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
            child:Text('Login',
              style:Theme.of(context).primaryTextTheme.labelLarge),
            onPressed:(){
              if((_formKey.currentState as FormState).validate()){
                (_formKey.currentState as FormState).save();
                print('email:$_email,password:$_password');
              }
            },
          autofocus: true,
        ),
      ),
    );
  }
  
  Widget buildSigninButton(){
    return Align(
      child:SizedBox(
        height: 50,
        width: 140,
        child: ElevatedButton(

          style:ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            minimumSize: MaterialStateProperty.all(Size(100,50)),
              side:MaterialStateProperty.all(BorderSide(color:Colors.grey,width: 1)),

          ),
          child:Text('Sign ',
          style:Theme.of(context).primaryTextTheme.labelLarge),
          onPressed:(){
            //TOGO
          },
          autofocus: true,
        ),
      ),
    );
  }

}




