import 'package:dicionario/DS/Components/theme/Theme_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final theme = Theme.of(context);

    final buttonColor = theme.brightness == Brightness.light
      ? Colors.black.withOpacity(0.1)
      : Colors.yellow.withOpacity(0.1);


    final iconColor = theme.brightness == Brightness.light
        ? Colors.blueGrey.shade700
        : Colors.amber[600];
        

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: buttonColor,
        shape: BoxShape.circle,
      ),
        
      child: IconButton(
        icon: Icon(
          themeService.isDarkMode ? Icons.wb_sunny : Icons.nights_stay_sharp,
          color: iconColor,
        ),
        tooltip: themeService.isDarkMode
            ? "Mudar para tema claro"
            : "Mudar para tema escuro",
        onPressed: () {
          context.read<ThemeService>().toggleTheme();
        },
      ),
    );
  }
}
