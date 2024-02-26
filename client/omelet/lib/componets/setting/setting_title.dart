import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omelet/models/setting.dart';

class SettingTitle extends StatelessWidget {
  final Setting setting;
  const SettingTitle({
    super.key, 
    required this.setting,});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
    onTap: (){}, //navigation
      child:Row(
        children: [
          Container(
            height: 40,
            width: 40,
            margin:const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 190, 190),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(setting.icon,color:const Color.fromARGB(255, 255, 255, 255)),
          ),
          const SizedBox(width: 10),
          Text(
            setting.title,
            style: textTheme.titleSmall,
          ),
          const Spacer(),
            Icon(CupertinoIcons.chevron_forward,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      );
    }
  }
