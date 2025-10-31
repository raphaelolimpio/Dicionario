import 'package:dicionario/DS/Components/theme/Theme_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget{
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final themeService = context.watch<ThemeService>();
   return IconButton(
    icon: Icon(
      themeService.isDarkMode ? Icons.wb_sunny :  Icons.nights_stay_sharp,
      color: themeService.isDarkMode ?  Colors.yellow : Colors.grey,
    ),
    tooltip: themeService.isDarkMode ? "Mudar para tema claro" : "Mudar para tema escuro",
    onPressed: (){
      context.read<ThemeService>().toggleTheme();
    },
   );
  }
}