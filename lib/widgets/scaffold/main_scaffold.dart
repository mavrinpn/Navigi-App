import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavBar,
    this.canPop = true,
    this.resize = false,
    this.topSafeArea = true,
  });

  final AppBar? appBar;
  final Widget body;
  final Widget? bottomNavBar;
  final bool canPop;
  final bool resize;
  final bool topSafeArea;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPop,
        child: SafeArea(
          top: topSafeArea,
          child: Scaffold(
            appBar: appBar,
            body: body,
            bottomNavigationBar: bottomNavBar,
          ),
        ));
  }
}
