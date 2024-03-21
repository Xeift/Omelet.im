import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:omelet/theme/theme_constants.dart';

// ignore: must_be_immutable
class FrostedAppbar extends StatefulWidget {
  double height;
  Widget title;
  Widget leading;
  List<Widget> actions;
  Color color;
  double blurStrengthX;
  double blurStrengthY;

  FrostedAppbar({
    super.key,
    this.height = 70,
    required this.actions,
    required this.blurStrengthX,
    required this.blurStrengthY,
    required this.color,
    required this.leading,
    required this.title,
    required IconThemeData iconTheme,
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
                color: darkMode.iconTheme.color,
                child: widget.leading,
              ),
              Expanded(
                child: widget.title,
              ),
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
