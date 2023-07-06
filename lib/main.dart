import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc/auth/auth_cubit.dart';
import 'package:smart/data/app_repository.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/data/places_manager.dart';
import 'package:smart/feature/create_announcement/ui/creating_screens.dart';
import 'package:smart/feature/main/bloc/announcement_cubit.dart';
import 'package:smart/feature/main/bloc/announcement_manager.dart';
import 'package:smart/feature/registration/ui/register_screen.dart';
import 'package:smart/services/custom_bloc_observer.dart';
import 'package:smart/services/database_manager.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/app/app_cubit.dart';
import 'feature/announcement/bloc/announcement_cubit.dart';
import 'feature/announcement/ui/announcement_screen.dart';
import 'feature/create_announcement/bloc/creating_blocs.dart';
import 'feature/create_announcement/data/categories_manager.dart';
import 'feature/create_announcement/data/creating_announcement_manager.dart';
import 'feature/create_announcement/data/item_manager.dart';
import 'feature/create_announcement/ui/search_place_screen.dart';
import 'feature/home/ui/home_screen.dart';
import 'feature/login/ui/login_first_screen.dart';
import 'feature/login/ui/login_second_screen.dart';
import 'feature/main/ui/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = CustomBlocObserver();
  runApp(MyRepositoryProviders());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.mainBackground,
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
      },
      color: const Color(0xff292B57),
    );
  }
}

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);
  final client = Client()
      .setEndpoint('http://89.253.237.166/v1')
      .setProject('64987d0f7f186b7e2b45');

  @override
  Widget build(BuildContext context) {
    DatabaseManger dbManager = DatabaseManger(client: client);

    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (_) => AppRepository(client: client),
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
            appRepository: RepositoryProvider.of<AppRepository>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => AppCubit(
            appRepository: RepositoryProvider.of<AppRepository>(context)),
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
            return Center(child: AppAnimations.circleFadingAnimation);
          }
        },
      ),
    );
  }
}
