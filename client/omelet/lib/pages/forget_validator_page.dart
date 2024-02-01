import 'package:flutter/material.dart';

class ForgetValidator extends StatefulWidget{
  const ForgetValidator({Key? key}):super(key: key);
  @override
  _ValidationPage createState() => _ValidationPage();
}

class _ValidationPage extends State<ForgetValidator>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(
          icon:const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
            
          ),
      ),
    );
  }
  Widget buildValidation_textField(){
      return const TextField(
        decoration: InputDecoration(
          border:OutlineInputBorder(
            
          ),
          labelText: "Email Validation Input",
        ),
        
      );
    }
}
