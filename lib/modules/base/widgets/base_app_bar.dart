import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final Widget? title;
  final String postFixtitleText;
  final bool centerTitle;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  const BaseAppBar({
    super.key,
    this.centerTitle = true,
    this.titleText = "Expense",
    this.title,
    this.actions,
    this.postFixtitleText = "",
    this.bottom,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? Text("$titleText$postFixtitleText"),
      centerTitle: centerTitle,
      actions: actions,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      toolbarHeight: toolbarHeight,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
