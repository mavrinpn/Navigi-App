import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/favorites/favorites_screen.dart';
import 'package:smart/feature/home/bloc/scroll/scroll_cubit.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';
import 'package:smart/feature/messenger/ui/all_chats_screen.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../utils/colors.dart';
import '../../main/ui/main_screen.dart';
import '../../profile/ui/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  int _targetTab = 0;

  @override
  void initState() {
    super.initState();
    _pushProcessing();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    super.dispose();
  }

  void _pushProcessing() {
    selectNotificationStream.stream.listen((String payload) {
      final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);
      messengerRepository.preloadChats().then((value) {
        messengerRepository.selectChat(id: payload);
        Navigator.pushNamed(context, AppRoutesNames.chat);
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null && message.data['room_id'] != null) {
        selectNotificationStream.add(message.data['room_id']);
      }
    });
    MessagingService.checkInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<Widget> widgetOptions = <Widget>[
      const MainScreen(),
      const MessengerMainScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    void onSelectTab(int index) {
      if (_selectedTab == index) {
        if (index == 0) {
          context.read<ScrollCubit>().scrollToTop();
        }
        return;
      }

      final isUserAith = context.read<AppCubit>().state is AppAuthState;
      if (index != 0 && !isUserAith) {
        _targetTab = index;
        Navigator.of(context).pushNamed(
          AppRoutesNames.loginFirst,
          arguments: {'showBackButton': true},
        );
        return;
      }

      // if (index == 1 && isUserAith) {
      //   final messengerRepository =
      //       RepositoryProvider.of<MessengerRepository>(context);
      //   //* preloadChats
      //   messengerRepository.preloadChats();
      //   messengerRepository.refreshSubscription();
      // }

      if (index == 3) {
        BlocProvider.of<CreatorCubit>(context).setUserId(RepositoryProvider.of<AuthRepository>(context).userId);
      }

      setState(() {
        _selectedTab = index;
      });
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocListener<AppCubit, AppState>(
          listener: (context, state) {
            if (state is AppAuthState) {
              _showTargetScreenOnLogin();
            } else {
              _showMainScreenOnLogout();
            }
          },
          child: IndexedStack(
            index: _selectedTab,
            children: widgetOptions,
          ),
          // child: widgetOptions[_selectedTab],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xffDEE2E7), width: 1))),
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
                  tooltip: MyApp.getLocale(context) == 'fr' ? 'Page daccueil' : 'الصفحة الرئيسية',
                  label: MyApp.getLocale(context) == 'fr' ? 'Page daccueil' : 'الصفحة الرئيسية'),
              BottomNavigationBarItem(
                icon: MessengerIcon(
                  isSelected: _selectedTab == 1,
                ),
                tooltip: localizations.messages,
                label: localizations.messages,
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/like.svg',
                  isSelected: _selectedTab == 2,
                ),
                tooltip: MyApp.getLocale(context) == 'fr' ? 'Délection' : 'المتعة',
                label: MyApp.getLocale(context) == 'fr' ? 'Délection' : 'المتعة',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/profile.svg',
                  isSelected: _selectedTab == 3,
                ),
                tooltip: localizations.profile,
                label: localizations.profile,
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
    );
  }

  void _showTargetScreenOnLogin() {
    setState(() {
      _selectedTab = _targetTab;
    });
    //Navigator.of(context).pop();
    Navigator.popUntil(context, ModalRoute.withName(AppRoutesNames.root));
  }

  void _showMainScreenOnLogout() {
    setState(() {
      _selectedTab = 0;
    });
  }
}

class NavigatorBarItem extends StatelessWidget {
  const NavigatorBarItem({Key? key, required this.asset, required this.isSelected}) : super(key: key);

  final String asset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      height: 24,
      width: 24,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.red : AppColors.lightGray,
        BlendMode.srcIn,
      ),
    );
  }
}

class MessengerIcon extends StatelessWidget {
  const MessengerIcon({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<MessengerRepository>(context);

    return StreamBuilder(
      stream: repository.chatsStream.stream,
      builder: (context, snapshot) {
        int notificationsAmount = repository.notificationsAmount();
        double size = 24;

        return SizedBox(
          width: size + 3,
          height: size,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  'Assets/icons/email.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.red : AppColors.lightGray,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              if (notificationsAmount > 0) ...[
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFFFB039),
                    radius: 6,
                    child: Text(
                      notificationsAmount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
