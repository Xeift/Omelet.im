import 'package:flutter/material.dart';


class NotificationPgae extends StatefulWidget {
  const NotificationPgae({Key? key}) : super(key: key);

  @override
  State<NotificationPgae> createState() => _MessagePageState();
}

class _MessagePageState extends State<NotificationPgae> {
  @override


  @override
  Widget build(BuildContext context) {
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    return const Center(
      child:Text('NotificationPgae'),
    );
  }
}