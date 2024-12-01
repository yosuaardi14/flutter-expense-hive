import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final String postFixtitleText;
  final bool centerTitle;
  final List<Widget>? actions;
  const BaseAppBar({
    super.key,
    this.centerTitle = true,
    this.titleText = "Expense App",
    this.actions,
    this.postFixtitleText = "",
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("$titleText$postFixtitleText"),
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
