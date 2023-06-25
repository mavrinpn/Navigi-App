import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            items: [
              BottomNavigationBarItem(
                  icon: NavigatorBarItem(
                    asset: 'Assets/icons/search.svg',
                    isSelected: _selectedTab == 0,
                  ),
                  tooltip: 'Page daccueil',
                  label: 'Page daccueil'),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/email.svg',
                  isSelected: _selectedTab == 1,
                ),
                tooltip: 'Messages',
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/like.svg',
                  isSelected: _selectedTab == 2,
                ),
                tooltip: 'Délection',
                label: 'Délection',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/profile.svg',
                  isSelected: _selectedTab == 3,
                ),
                tooltip: 'Mon profil',
                label: 'Mon profil',
              ),
            ],

            selectedLabelStyle: AppTypography.font10pink,
            unselectedLabelStyle: AppTypography.font10lightGray,
            onTap: onSelectTab,
            selectedItemColor: AppColors.red,
            unselectedItemColor: AppColors.lightGray,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}

class NavigatorBarItem extends StatelessWidget {
  const NavigatorBarItem(
      {Key? key, required this.asset, required this.isSelected})
      : super(key: key);

  final String asset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        asset,
        height: 24,
        width: 24,
        color: isSelected ? AppColors.red : AppColors.lightGray,
    );
  }
}
