import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/feature/announcement_editing/ui/editing_announcement_screen.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_location_widget.dart';
import 'package:smart/feature/main/ui/main_page.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/firebase_options.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/providers.dart';
import 'package:smart/restart_controller.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/app_theme.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/routes/routes.dart';

final ValueNotifier<String> currentLocaleShortName = ValueNotifier<String>('fr');
const langKey = 'langKey';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  currentLocaleShortName.value = prefs.getString(langKey) ?? 'fr';

  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 50;

  Bloc.observer = CustomBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load();

  FirebaseMessaging.onBackgroundMessage(MessagingService.onBackgroundMessage);

  runApp(HotRestartController(
    child: MyRepositoryProviders(prefs: prefs),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocate(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static String? getLocale(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    return state?._locale?.languageCode;
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    RepositoryProvider.of<AuthRepository>(context).appMounted = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setLocale(Locale(currentLocaleShortName.value));

    final searchCubit = context.read<SearchAnnouncementCubit>();
    final cityDistrictString = widget.prefs.getString(cityDistrictKey);
    if (cityDistrictString != null) {
      final cityDistrict = CityDistrict.fromMap(jsonDecode(cityDistrictString));
      searchCubit.setCity(
        cityId: cityDistrict.cityId,
        areaId: cityDistrict.id,
        cityTitle: cityDistrict.cityTitle,
        areaTitle: cityDistrict.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      title: 'Navigi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routes: {
        AppRoutesNames.root: (context) => const MainPage(),
        AppRoutesNames.editingAnnouncement: (context) => const EditingAnnouncementScreen(),
      },
      onGenerateRoute: onGenerateRoute,
      color: const Color(0xff292B57),
    );
  }
}
