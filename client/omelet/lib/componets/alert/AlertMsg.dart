// ignore: file_names
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
void LoginEorroMsg(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('提示'),
        backgroundColor: Colors.white,
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              'CLOSE',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
