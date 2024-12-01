import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/auth/ui/user_data_screen.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/feature/main/bloc/announcement/announcement_container_cubit.dart';
import 'package:smart/feature/search/ui/loading_mixin.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';
import 'package:smart/widgets/splash.dart';

late InternetConnection internetConnection;

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with LoadingMixin {
  bool? _firstLoginHasConnection;
  bool isSplahScreen = false;
  bool _needRefresh = false;
  late StreamSubscription<InternetStatus> _internetConnectionSubscription;

  @override
  void initState() {
    super.initState();

    internetConnection = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 20),
    );
    _internetConnectionSubscription = internetConnection.onStatusChange.listen((InternetStatus status) async {
      final localizations = AppLocalizations.of(context)!;
      switch (status) {
        case InternetStatus.connected:
          _firstLoginHasConnection = true;

          final authRepository = RepositoryProvider.of<AuthRepository>(context);
          await authRepository.checkLogin();

          if (_needRefresh) {
            _needRefresh = false;
            BlocProvider.of<AnnouncementContainerCubit>(context).reloadImages();
          }
          setState(() {});
          break;

        case InternetStatus.disconnected:
          _firstLoginHasConnection ??= false;

          _needRefresh = true;
          if (!isSplahScreen) {
            Future.delayed(
              const Duration(milliseconds: 1000),
              () {
                InternetConnection().hasInternetAccess.then((connected) {
                  if (!connected) {
                    CustomSnackBar.showSnackBarWithIcon(
                      context: context,
                      text: localizations.noConnection,
                      iconData: Icons.wifi_off,
                    );
                  }
                });
              },
            );
          }

          setState(() {});
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
          isSplahScreen = false;
          if (state is AppAuthState || state is AppUnAuthState) {
            return const HomeScreen();
          } else if (state is AppAuthWithNoDataState) {
            return const UserDataScreen();
          } else {
            isSplahScreen = true;
            return Splash(
              showConnectedButton: _firstLoginHasConnection == false,
              resetLoginHasConnection: () {
                _firstLoginHasConnection = null;
                setState(() {});
                Future.delayed(
                  const Duration(milliseconds: 3000),
                  () {
                    InternetConnection().hasInternetAccess.then((connected) {
                      if (!connected) {
                        _firstLoginHasConnection ??= false;
                        setState(() {});
                      }
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
