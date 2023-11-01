import 'package:flutter/material.dart';

class ValidationPage extends StatefulWidget{
  const ValidationPage({Key? key}):super(key: key);
  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage>{
  late String _ValidationNum = '';
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