import 'package:flutter/material.dart';

class ForgetValidator extends StatefulWidget{
  const ForgetValidator({Key? key}):super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ValidationPage createState() => _ValidationPage();
}

class _ValidationPage extends State<ForgetValidator>{

  // ignore: unused_field
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
  // ignore: non_constant_identifier_names
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
