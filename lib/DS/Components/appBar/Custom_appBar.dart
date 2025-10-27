import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final VoidCallback? onShowFavorites;
  final bool isFaroritePage;
  final Widget? searchWidget;
  final bool isSearchExpanded;
  final Widget? titleWidget;

  const CustomAppBar({
    super.key,
    this.backgroundColor = appBarColor,
    this.onShowFavorites,
    this.isFaroritePage = false,
    this.searchWidget,
    this.isSearchExpanded = false,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      iconTheme: const IconThemeData(color: WhiteIconColor),
      title: titleWidget ?? const Text(
        "Dicononário de Dev",
        style: TextStyle(color: Colors.white),
      ),
      actions: [if (searchWidget != null) searchWidget!],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
