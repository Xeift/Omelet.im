import 'dart:ui';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FrostedAppbar extends StatefulWidget {
  double height;
  Widget title;
  Widget leading;
  List<Widget> actions;
  Color color;
  double blurStrengthX; // 修正拼寫錯誤
  double blurStrengthY;

  FrostedAppbar({
    super.key,
    this.height = 70,
    required this.actions,
    required this.blurStrengthX, // 修正拼寫錯誤
    required this.blurStrengthY, // 修正拼寫錯誤
    required this.color,
    required this.leading,
    required this.title, // 修正冒號錯誤
  });
  @override
  FrostedAppbarState createState() => FrostedAppbarState();
}

class FrostedAppbarState extends State<FrostedAppbar> {
  @override
  Widget build(BuildContext context) {
    var scrSize = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurStrengthX,
          sigmaY: widget.blurStrengthY,
        ),
        child: Container(
          color: widget.color,
          alignment: Alignment.center,
          width: scrSize.width,
          height: widget.height,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 0),
                width: 56,
                color: Colors.transparent,
                child: widget.leading,
              ),
              Expanded(
                child: widget.title,
              ),
              // 移除這裡的逗號
              Row(
                children: widget.actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
