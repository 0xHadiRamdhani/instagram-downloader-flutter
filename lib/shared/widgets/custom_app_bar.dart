import 'package:flutter/material.dart';
import 'package:instagram_downloader/core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.textColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? AppColors.surface;
    final txtColor = textColor ?? AppColors.textPrimary;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: txtColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios, color: txtColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      iconTheme: IconThemeData(color: txtColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
