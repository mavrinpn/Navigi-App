import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _widgetOptions = <Widget>[
    const Text(''),
    const Text(''),
    const Text(''),
    const Text(''),
  ];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    void onSelectTab(int index) {
      if (_selectedTab == index) return;
      setState(() {
        _selectedTab = index;
      });
    }

    return WillPopScope(
      child: Scaffold(
        body: _widgetOptions[_selectedTab],
        bottomNavigationBar: ClipRRect(
          child: BottomNavigationBar(
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedTab,
            items: const [
              BottomNavigationBarItem(
                icon: NavigatorBarItem(asset: 'Assets/search.png',),
                tooltip: 'Page daccueil',
                label: 'Page daccueil'
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(asset: 'Assets/message.png',),
                tooltip: 'Messages',
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(asset: 'Assets/heart.png',),
                tooltip: 'Délection',
                label: 'Délection',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(asset: 'Assets/People.png',),
                tooltip: 'Mon profil',
                label: 'Mon profil',
              ),
            ],
            selectedLabelStyle: AppTypography.font10pink,
            unselectedLabelStyle: AppTypography.font10lightGray,
            onTap: onSelectTab,
            selectedItemColor: AppColors.pink,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}

class NavigatorBarItem extends StatelessWidget {
  const NavigatorBarItem({Key? key, required this.asset}) : super(key: key);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 22,
        height: 22,
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage(asset))));
  }
}
