import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/ui/loading_mixin.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';
import 'package:smart/widgets/splash.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with LoadingMixin {
  bool hasConnection = true;
  late StreamSubscription<InternetStatus> _internetConnectionSubscription;

  @override
  void initState() {
    super.initState();

    final connection = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 10),
    );
    _internetConnectionSubscription = connection.onStatusChange.listen((InternetStatus status) {
      final localizations = AppLocalizations.of(context)!;
      switch (status) {
        case InternetStatus.connected:
          break;
        case InternetStatus.disconnected:
          CustomSnackBar.showSnackBarWithIcon(
            context: context,
            text: localizations.noConnection,
            iconData: Icons.wifi_off,
          );
          break;
      }
    });
  }

  @override
  dispose() {
    _internetConnectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is AppAuthState || state is AppUnAuthState) {
            return BlocListener<SearchAnnouncementCubit, SearchAnnouncementState>(
              listener: (context, state) {
                if (state is SearchAnnouncementsLoadingState) {
                  showLoadingOverlay(context);
                } else {
                  hideLoadingOverlay(context);
                }
              },
              child: const HomeScreen(),
            );
          } else {
            return const Splash();
          }
        },
      ),
    );
  }
}
