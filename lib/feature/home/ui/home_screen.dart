// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc/auth/auth_cubit.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_elevated_button.dart';

import '../../../utils/colors.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../main/ui/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const MainScreen(),
      const Text('Messages'),
      const Text('Delection'),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton.withIcon(
                callback: () {
                  Navigator.pushNamed(context, '/create_category_screen');
                },
                text: 'Ajouter une annonce',
                styleText: AppTypography.font14white,
                isTouch: true,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                  icon: "Assets/icons/exit.svg",
                  title: "Se déconnecter du compte",
                  onPress: () {
                    BlocProvider.of<AuthCubit>(context).logout();
                  },
                  height: 52,
                  width: double.infinity)
            ],
          ),
        ),
      )
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
            border: Border(top: BorderSide(color: Color(0xffDEE2E7), width: 1))
          ),
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
                tooltip: 'Mon profil',
                label: 'Mon profil',
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
      color: isSelected ? AppColors.red : AppColors.lightGray,
    );
  }
}
