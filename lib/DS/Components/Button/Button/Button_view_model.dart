import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

enum ButtonTextStyle { buttonStyle1, buttonStyle2 }

enum ButtonStyleColor { redColor, greenColor, cyanColor, orangeColor }

class ButtonViewModel {
  final ButtonSize size;
  final ButtonStyleColor style;
  final ButtonTextStyle textStyle;
  final String title;
  final IconData? icon;
  final Function() onPressed;

  ButtonViewModel({
    required this.size,
    required this.style,
    required this.textStyle,
    required this.title,
    this.icon,
    required this.onPressed, required String text,
  });
}
