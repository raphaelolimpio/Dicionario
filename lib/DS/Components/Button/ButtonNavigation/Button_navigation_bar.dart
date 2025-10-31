import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar_view_model.dart';
import 'package:flutter/material.dart';



class ButtonNavigationBar extends StatelessWidget {
  final List<ButtonNavigationBarViewModel> items;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const ButtonNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
   return BottomNavigationBar(
    backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,

      items: items.map((viewModel) {
        return BottomNavigationBarItem(
          icon: Icon(viewModel.icon, size: 20,),
          label: viewModel.name, 
          activeIcon: Icon(viewModel.icon, color: theme.bottomNavigationBarTheme.selectedItemColor, size: 30,),
          
        );
      }).toList(),
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      selectedFontSize: 16,
      unselectedFontSize: 12,
  
    );
  }
}