import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/announcement/bloc/announcement/announcement_cubit.dart';
import 'package:smart/feature/announcement/data/creator_repository.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/feature/announcement_editing/data/announcement_editing_repository.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/feature/create_announcement/bloc/creating/creating_announcement_cubit.dart';
import 'package:smart/feature/create_announcement/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/managers/favourites_manager.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/storage_service.dart';

import 'main.dart';
import 'managers/announcement_manager.dart';
import 'managers/categories_manager.dart';
import 'managers/creating_announcement_manager.dart';
import 'managers/item_manager.dart';
import 'managers/places_manager.dart';
import 'managers/search_manager.dart';

import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/feature/main/bloc/announcements/announcement_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/main/bloc/search/search_announcements_cubit.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';

import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';

import 'package:appwrite/appwrite.dart' as a;

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);

  final client = a.Client()
      .setEndpoint('http://admin.navigidz.online/v1')
      .setProject('64fb37419dc681fa6860');

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService(client: client);
    FileStorageManager storageManager = FileStorageManager(client: client);

    MessagingService messagingService =
        MessagingService(databaseService: databaseService);

    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (_) => AuthRepository(
            client: client,
            databaseService: databaseService,
            messagingService: messagingService,
            fileStorageManager: storageManager),
      ),
      RepositoryProvider(
        create: (_) => CreatingAnnouncementManager(client: client),
      ),
      RepositoryProvider(
        create: (_) => ItemManager(databaseService: databaseService),
      ),
      RepositoryProvider(
        create: (_) => CategoriesManager(databaseService: databaseService),
      ),
      RepositoryProvider(
        create: (_) => AnnouncementManager(client: client),
      ),
      RepositoryProvider(
        create: (_) => PlacesManager(databaseService: databaseService),
      ),
      RepositoryProvider(
        create: (_) => MessengerRepository(databaseService: databaseService),
      ),
      RepositoryProvider(
        create: (_) => SearchManager(client: client),
      ),
      RepositoryProvider(
          create: (_) => CreatorRepository(databaseService: databaseService)),
      RepositoryProvider(
          create: (_) => FavouritesManager(databaseService: databaseService)),
      RepositoryProvider(
          create: (_) =>
              AnnouncementEditingRepository(databaseService, storageManager))
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
            authRepository: RepositoryProvider.of<AuthRepository>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => AppCubit(
            appRepository: RepositoryProvider.of<AuthRepository>(context),
            messengerRepository:
                RepositoryProvider.of<MessengerRepository>(context),
            announcementManager:
                RepositoryProvider.of<AnnouncementManager>(context),
            favouritesManager:
                RepositoryProvider.of<FavouritesManager>(context)),
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
        create: (_) => AnnouncementEditCubit(
            RepositoryProvider.of<AnnouncementEditingRepository>(context),
            RepositoryProvider.of<AnnouncementManager>(context)),
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
      BlocProvider(
        create: (_) => FavouritesCubit(
          favouritesManager: RepositoryProvider.of<FavouritesManager>(context),
        ),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => CreatorCubit(
          creatorRepository: RepositoryProvider.of<CreatorRepository>(context),
        ),
        lazy: false,
      ),
    ], child: const MyApp());
  }
}
