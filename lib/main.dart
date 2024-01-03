import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/firebase_options.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/providers.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/colors.dart';
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
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
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
      ),
      routes: appRoutes,
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


// {
// '/': (context) => const HomePage(),
// // '/': (context) => const CodeScreen(),
// '/login_first_screen': (context) => const LoginFirstScreen(),
// '/login_code_screen': (context) => const CodeScreen(),
// '/login_second_screen': (context) => const LoginSecondScreen(),
// '/register_screen': (context) => const RegisterScreen(),
// '/home_screen': (context) => const HomeScreen(),
// '/create_category_screen': (context) => const CategoryScreen(),
// '/create_sub_category_screen': (context) => const SubCategoryScreen(),
// '/create_search_products_screen': (context) =>
// const SearchProductsScreen(),
// '/create_pick_photos_screen': (context) => const PickPhotosScreen(),
// '/create_by_not_by_screen': (context) => const ByNotByScreen(),
// '/create_description': (context) => const DescriptionScreen(),
// '/create_search_places_screen': (context) => const SearchPlaceScreen(),
// '/loading_screen': (context) => const LoadingScreen(),
// '/create_options_screen': (context) => const OptionsScreen(),
// '/main_screen': (context) => const MainScreen(),
// '/announcement_screen': (context) => const AnnouncementScreen(),
// '/edit_profile_screen': (context) => const EditProfileScreen(),
// '/settings_screen': (context) => const SettingsScreen(),
// '/search_screen': (context) => const SearchScreen(),
// '/creator_screen': (context) => const CreatorProfileScreen(),
// '/chat_screen': (context) => const ChatScreen(),
// }