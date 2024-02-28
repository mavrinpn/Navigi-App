import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/search/ui/search_screen.dart';
import 'package:smart/firebase_options.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/providers.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/routes/routes.dart';
import 'package:smart/widgets/splash.dart';

import 'bloc/app/app_cubit.dart';
import 'feature/auth/ui/login_first_screen.dart';
import 'feature/home/ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 50;
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();
  FirebaseMessaging.onBackgroundMessage(MessagingService.onBackgroundMessage);
  runApp(MyRepositoryProviders());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    RepositoryProvider.of<AuthRepository>(context).appMounted =
        state == AppLifecycleState.resumed;
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

    setLocale(const Locale('fr'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      title: 'Navigi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.mainBackground,
        scaffoldBackgroundColor: AppColors.mainBackground,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.mainBackground, elevation: 0),
        fontFamily: GoogleFonts.nunito().fontFamily,
        chipTheme: const ChipThemeData(
          showCheckmark: false,
          selectedColor: Color(0xffED5434),
          backgroundColor: Color(0xffF4F5F6),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
      ),
      routes: appRoutes,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutesNames.search) {
          final arguments = settings.arguments as Map<String, dynamic>;
          final query = arguments['query'] as String?;
          final title = arguments['title'] as String?;
          final showBackButton = arguments['showBackButton'] as bool?;

          return MaterialPageRoute(
            builder: (context) {
              return SearchScreen(
                showBackButton: showBackButton ?? true,
                title: title ?? '',
                queryString: query,
              );
            },
          );
        }
        return MaterialPageRoute(
          builder: (context) {
            return const Text('Page not found');
          },
        );
      },
      color: const Color(0xff292B57),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is AppAuthState) {
            return const HomeScreen();
          } else if (state is AppUnAuthState) {
            return const Center(
              child: LoginFirstScreen(),
            );
          } else {
            return const Splash();
          }
        },
      ),
    );
  }
}
