import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/utils/fonts.dart';

import '../../../managers/categories_manager.dart';
import '../../../utils/colors.dart';
import '../../main/ui/main_screen.dart';
import '../../profile/ui/profile_screen.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;


    final List<Widget> widgetOptions = <Widget>[
      const MainScreen(),
      Center(
        child: InkWell(onTap: () async{
          var a = await RepositoryProvider.of<AnnouncementManager>(context).addLimitAnnouncements();
        },
          child: Text('asdf'),
        ),
      ),
      const Text('Delection'),
      const ProfileScreen(),
    ];

    void onSelectTab(int index) {
      if (_selectedTab == index) return;
      setState(() {
        _selectedTab = index;
      });
    }

    return WillPopScope(
      child: Scaffold(
        body: widgetOptions[_selectedTab],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xffDEE2E7), width: 1))),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xffFBFBFC),
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
                tooltip: localizations.myProfile,
                label: localizations.myProfile,
              ),
            ],
            selectedLabelStyle: AppTypography.font10red,
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
      // ignore: deprecated_member_use
      color: isSelected ? AppColors.red : AppColors.lightGray,
    );
  }
}
