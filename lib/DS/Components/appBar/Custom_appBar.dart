import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final VoidCallback? onShowFavorites;
  final VoidCallback? onShowCart;
  final bool isFaroritePage;
  final bool isCartPage;

  const CustomAppBar({
    super.key,
    this.backgroundColor = appBarColor,
    this.onShowFavorites,
    this.onShowCart,
    this.isFaroritePage = false,
    this.isCartPage = false,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.menu),
        color: BlackIconColor,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
