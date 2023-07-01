import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart/bloc/app_cubit.dart';
import 'package:smart/bloc/auth_cubit.dart';
import 'package:smart/data/app_repository.dart';
import 'package:smart/feature/create/bloc/category/category_cubit.dart';
import 'package:smart/feature/create/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create/data/categories_manager.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';
import 'package:smart/feature/create/ui/descritpion_screen.dart';
import 'package:smart/feature/registration/ui/register_screen.dart';
import 'package:smart/services/custom_bloc_observer.dart';
import 'package:smart/services/file_storage.dart';
import 'package:smart/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'feature/create/bloc/creating/creating_anounce_cubit.dart';
import 'feature/create/bloc/sub_category/sub_category_cubit.dart';
import 'feature/create/data/item_manager.dart';
import 'feature/create/ui/category_screen.dart';
import 'feature/create/ui/options_screen.dart';
import 'feature/create/ui/loading_screen.dart';
import 'feature/create/ui/pick_photo_screen.dart';
import 'feature/create/ui/choose_type_screen.dart';
import 'feature/create/ui/search_products_screen.dart';
import 'feature/create/ui/sub_category_screen.dart';
import 'feature/home/ui/home_screen.dart';
import 'feature/login/ui/login_first_screen.dart';
import 'feature/login/ui/login_second_screen.dart';

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
        '/loading_screen': (context) => const LoadingScreen(),
        '/create_options_screen': (context) => const OptionsScreen(),
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
    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (_) => AppRepository(client: client),
      ),
      RepositoryProvider(
        create: (_) => CreatingAnnouncementManager(client: client),
      ),
      RepositoryProvider(
        create: (_) => ItemManager(client: client),
      ),
      RepositoryProvider(
        create: (_) => CategoriesManager(client: client),
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
            creatingManager:
                RepositoryProvider.of<CreatingAnnouncementManager>(context),
            categoriesManager:
                RepositoryProvider.of<CategoriesManager>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => SubCategoryCubit(
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
        create: (_) => CreatingAnounceCubit(
            creatingAnnouncementManager:
                RepositoryProvider.of<CreatingAnnouncementManager>(context),
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
            return Center(
              child: SpinKitFadingCircle(
                itemBuilder: (_, ind) {
                  return const Padding(
                    padding: EdgeInsets.all(1.8),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: AppColors.red, shape: BoxShape.circle)),
                  );
                },
                size: 86,
              ),
            );
          }
        },
      ),
    );
  }
}
