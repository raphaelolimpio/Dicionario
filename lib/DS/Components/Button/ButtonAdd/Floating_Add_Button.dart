import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool mini;

  static const FloatingActionButtonLocation defaultLocation =
      FloatingActionButtonLocation.endFloat;

  const FloatingAddButton({
    super.key,
    this.onPressed,
    this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip ?? 'Adicionar',
      mini: mini,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      child: icon ?? const Icon(Icons.add),
    );
  }
}
