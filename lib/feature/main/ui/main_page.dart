import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';
import 'package:smart/widgets/splash.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool hasConnection = true;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late StreamSubscription<InternetStatus> _internetConnectionSubscription;

  @override
  void initState() {
    super.initState();
    // initConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    final connection = InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse('$serviceProtocol$serviceDomain')),
      ],
    );
    _internetConnectionSubscription = connection.onStatusChange.listen((InternetStatus status) {
      final localizations = AppLocalizations.of(context)!;
      switch (status) {
        case InternetStatus.connected:
          // hasConnection = true;
          // setState(() {});
          break;
        case InternetStatus.disconnected:
          CustomSnackBar.showSnackBarWithIcon(
            context: context,
            text: localizations.noConnection,
            iconData: Icons.wifi_off,
          );
          // hasConnection = false;
          // setState(() {});
          break;
      }
    });
  }

  @override
  dispose() {
    // _connectivitySubscription.cancel();
    _internetConnectionSubscription.cancel();
    super.dispose();
  }

  // Future<void> initConnectivity() async {
  //   late List<ConnectivityResult> result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     debugPrint('Couldn\'t check connectivity status $e');
  //     return;
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }

  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
  //   setState(() {
  //     // hasConnection = !result.contains(ConnectivityResult.none);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          // if (!hasConnection) {
          //   return const NoConnection();
          // }
          if (state is AppAuthState || state is AppUnAuthState) {
            return const HomeScreen();
          } else {
            return const Splash();
          }
        },
      ),
    );
  }
}
