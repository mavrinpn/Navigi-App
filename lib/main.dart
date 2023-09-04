import 'package:appwrite/appwrite.dart' as a;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/ui/creating_screens.dart';
import 'package:smart/feature/main/bloc/announcements/announcement_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/main/bloc/search/search_announcements_cubit.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/feature/auth/ui/register_screen.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/widgets/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/app/app_cubit.dart';
import 'feature/announcement/bloc/announcement_cubit.dart';
import 'feature/announcement/ui/announcement_screen.dart';
import 'feature/auth/data/auth_repository.dart';
import 'feature/auth/ui/login_second_screen.dart';
import 'feature/create_announcement/bloc/creating_blocs.dart';
import 'feature/home/ui/home_screen.dart';
import 'feature/auth/ui/login_first_screen.dart';
import 'feature/main/ui/main_screen.dart';
import 'feature/profile/ui/edit_profile_screen.dart';
import 'feature/search/bloc/search_announcement_cubit.dart';
import 'feature/search/ui/search_screen.dart';
import 'feature/settings/ui/settings_screen.dart';
import 'managers/announcement_manager.dart';
import 'managers/categories_manager.dart';
import 'managers/creating_announcement_manager.dart';
import 'managers/item_manager.dart';
import 'managers/places_manager.dart';
import 'managers/search_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 50;
  Bloc.observer = CustomBlocObserver();
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
      title: 'Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.mainBackground,
        scaffoldBackgroundColor: AppColors.mainBackground,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.mainBackground, elevation: 0),
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/login_first_screen': (context) => const LoginFirstScreen(),
        '/login_second_screen': (context) => const LoginSecondScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/home_screen': (context) => const HomeScreen(),
        '/create_category_screen': (context) => const CategoryScreen(),
        '/create_sub_category_screen': (context) => const SubCategoryScreen(),
        '/create_search_products_screen': (context) =>
            const SearchProductsScreen(),
        '/create_pick_photos_screen': (context) => const PickPhotosScreen(),
        '/create_by_not_by_screen': (context) => const ByNotByScreen(),
        '/create_description': (context) => const DescriptionScreen(),
        '/create_search_places_screen': (context) => const SearchPlaceScreen(),
        '/loading_screen': (context) => const LoadingScreen(),
        '/create_options_screen': (context) => const OptionsScreen(),
        '/main_screen': (context) => const MainScreen(),
        '/announcement_screen': (context) => const AnnouncementScreen(),
        '/edit_profile_screen': (context) => const EditProfileScreen(),
        '/settings_screen': (context) => const SettingsScreen(),
        '/search_screen': (context) => const SearchScreen(),
      },
      color: const Color(0xff292B57),
    );
  }
}

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);

  final client = a.Client()
      .setEndpoint('http://admin.navigidz.online/v1')
      .setProject('64987d0f7f186b7e2b45');

  @override
  Widget build(BuildContext context) {
    DatabaseManger dbManager = DatabaseManger(client: client);
    FileStorageManager storageManager = FileStorageManager(client: client);

    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (_) => AuthRepository(
            client: client,
            databaseManger: dbManager,
            fileStorageManager: storageManager),
      ),
      RepositoryProvider(
        create: (_) => CreatingAnnouncementManager(client: client),
      ),
      RepositoryProvider(
        create: (_) => ItemManager(databaseManager: dbManager),
      ),
      RepositoryProvider(
        create: (_) => CategoriesManager(databaseManger: dbManager),
      ),
      RepositoryProvider(
        create: (_) => AnnouncementManager(client: client),
      ),
      RepositoryProvider(
        create: (_) => PlacesManager(databaseManager: dbManager),
      ),
      RepositoryProvider(
        create: (_) => SearchManager(client: client),
      ),
    ], child: const MyBlocProviders());
  }
}

class MyBlocProviders extends StatelessWidget {
  const MyBlocProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => AuthCubit(
            appRepository: RepositoryProvider.of<AuthRepository>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => AppCubit(
            appRepository: RepositoryProvider.of<AuthRepository>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => CategoryCubit(
            categoriesManager:
                RepositoryProvider.of<CategoriesManager>(context))
          ..loadCategories(),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => SubcategoryCubit(
            creatingManager:
                RepositoryProvider.of<CreatingAnnouncementManager>(context),
            categoriesManager:
                RepositoryProvider.of<CategoriesManager>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => ItemSearchCubit(
            creatingManager:
                RepositoryProvider.of<CreatingAnnouncementManager>(context),
            itemManager: RepositoryProvider.of<ItemManager>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => CreatingAnnouncementCubit(
          creatingAnnouncementManager:
              RepositoryProvider.of<CreatingAnnouncementManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => AnnouncementsCubit(
          announcementManager:
              RepositoryProvider.of<AnnouncementManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => AnnouncementCubit(
          announcementManager:
              RepositoryProvider.of<AnnouncementManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => PlacesCubit(
          creatingManager:
              RepositoryProvider.of<CreatingAnnouncementManager>(context),
          placesManager: RepositoryProvider.of<PlacesManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => UserCubit(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => PopularQueriesCubit(
          searchManager: RepositoryProvider.of<SearchManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => SearchItemsCubit(
          searchManager: RepositoryProvider.of<SearchManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => SearchAnnouncementCubit(
          announcementManager:
              RepositoryProvider.of<AnnouncementManager>(context),
        ),
        lazy: false,
      ),
    ], child: const MyApp());
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
