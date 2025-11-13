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

    final Color activeColor = theme.primaryColor;
    final Color inactiveColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;
    final Color shadowColor = Colors.black.withOpacity(0.15);
     

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 65,
          decoration: BoxDecoration(
            color: theme.bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final bool isActive = index == selectedIndex;

              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  transform: Matrix4.translationValues(
                    0,
                    isActive ? -20 : -5,
                    0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: isActive ? activeColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : [],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          item.icon,
                          color: isActive ? Colors.white : inactiveColor,
                          size: 30,
                        ),
                      ),
                     
                      
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (selectedIndex < 0 || selectedIndex >= items.length) {
                return const SizedBox.shrink();
              }

              final double itemWidth = constraints.maxWidth / items.length;
              final double centerX =
                  (itemWidth * selectedIndex) + (itemWidth / 2);

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    left: centerX - 30,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(width: 60, height: 20),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
