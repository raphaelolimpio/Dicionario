import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class IconCustom extends StatelessWidget {
  final IconViewModel viewModel;
  const IconCustom({super.key, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    double iconSize;
    switch (viewModel.size) {
      case IconSize.small:
        iconSize = 16.0;
        break;
      case IconSize.medium:
        iconSize = 24.0;
        break;
      case IconSize.large:
        iconSize = 32.0;
        break;
      default:
        iconSize = 24.0;
    }

    IconData iconData;
    switch (viewModel.icon) {
      case IconType.favorite:
        iconData = Icons.favorite;
        break;
      case IconType.settings:
        iconData = Icons.settings;
        break;
      case IconType.search:
        iconData = Icons.search;
        break;
      case IconType.home:
        iconData = Icons.home;
        break;
      case IconType.help:
        iconData = Icons.help;
        break;
      case IconType.fixed:
        iconData = Icons.push_pin_outlined;
        break;
      case IconType.folder:
        iconData = Icons.folder;
        break;
      case IconType.definition:
        iconData = Icons.psychology;
        break;
      case IconType.bash:
        iconData = Icons.computer;
        break;
      case IconType.dialog:
        iconData = Icons.chat_bubble;
        break;
      case IconType.dica:
        iconData = Icons.lightbulb;
        break;
    }

    Color iconColor;
    switch (viewModel.color) {
      case colorType.red:
        iconColor = RedBorderColor;
        break;
      case colorType.black:
        iconColor = BlackIconColor;
        break;
      case colorType.white:
        iconColor = WhiteIconColor;
        break;
      case colorType.blue:
        iconColor = BlueIconColor;
        break;
      case colorType.yellow:
        iconColor = ThemeCardIconColorYellow;
        break;
      case colorType.pink:
        iconColor = ThemeCardIconColorpink;
        break;
      case colorType.orange:
        iconColor = ThemeCardIconColororange;
        break;
      case colorType.green:
        iconColor = ThemeCardIconColorgreen;
        break;
      case colorType.darkblue:
        iconColor = ThemeCardIconColorDarkblue;
    }

    return Icon(iconData, size: iconSize, color: iconColor);
  }
}
