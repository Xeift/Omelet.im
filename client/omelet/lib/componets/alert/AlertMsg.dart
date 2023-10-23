import 'package:flutter/material.dart';

void LoginEorroMsg(BuildContext context,String message){
showDialog(
  context:context,
  builder:(BuildContext context){
  var Msg= context;
  return AlertDialog(
    title:Text('提示'),
    backgroundColor:Colors.white,
    content: Text(message),
    actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "CLOSE",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
    },
  );
}