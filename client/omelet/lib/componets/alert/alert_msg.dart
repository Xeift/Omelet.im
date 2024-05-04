import 'package:flutter/material.dart';

// 警告視窗

void loginErrorMsg(BuildContext context, String message) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reminds'),
          backgroundColor: const Color.fromARGB(255, 253, 168, 98),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'CLOSE',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        );
      },
    );
