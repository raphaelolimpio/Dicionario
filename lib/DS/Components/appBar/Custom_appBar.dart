import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final VoidCallback? onShowFavorites;
  final bool isFaroritePage;
  final Widget? searchWidget;
  final bool isSearchExpanded;
  final Widget? titleWidget;
  final Border? brder;

  const CustomAppBar({
    super.key,
    this.backgroundColor = appBarColor,
    this.onShowFavorites,
    this.isFaroritePage = false,
    this.searchWidget,
    this.isSearchExpanded = false,
    this.titleWidget,
    this.brder
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Visibility(
        visible: !isSearchExpanded,
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        child: titleWidget ?? const SizedBox.shrink()),
      actions: [if (searchWidget != null) searchWidget!],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
