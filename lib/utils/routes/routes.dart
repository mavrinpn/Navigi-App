import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/announcement/announcement_cubit.dart';
import 'package:smart/feature/announcement/bloc/related/related_announcement_cubit.dart';
import 'package:smart/feature/announcement/ui/announcement_screen.dart';
import 'package:smart/feature/announcement/ui/creator_screen.dart';
import 'package:smart/feature/announcement_editing/ui/editing_announcement.dart';
import 'package:smart/feature/auth/ui/code_screen.dart';
import 'package:smart/feature/auth/ui/login_first_screen.dart';
import 'package:smart/feature/auth/ui/login_second_screen.dart';
import 'package:smart/feature/auth/ui/register_screen.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/feature/main/ui/main_screen.dart';
import 'package:smart/feature/messenger/ui/chat_screen.dart';
import 'package:smart/feature/profile/ui/edit_profile_screen.dart';
import 'package:smart/feature/reviews/ui/create_review_screen.dart';
import 'package:smart/feature/reviews/ui/reviews_screen.dart';
import 'package:smart/feature/search/ui/search_screen.dart';
import 'package:smart/feature/search/ui/select_subcategory.dart';
import 'package:smart/feature/settings/ui/settings_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../feature/create_announcement/ui/creating_screens.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == AppRoutesNames.search) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final query = arguments['query'] as String?;
    final title = arguments['title'] as String?;
    final showBackButton = arguments['showBackButton'] as bool?;
    final showSearchHelper = arguments['showSearchHelper'] as bool?;

    return MaterialPageRoute(
      builder: (context) {
        return SearchScreen(
          showBackButton: showBackButton ?? true,
          showSearchHelper: showSearchHelper ?? true,
          title: title ?? '',
          searchQueryString: query,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.chat) {
    final arguments = settings.arguments as String?;
    return MaterialPageRoute(
      builder: (context) {
        return ChatScreen(message: arguments);
      },
    );
  } else if (settings.name == AppRoutesNames.reviews) {
    final arguments = settings.arguments as UserData;
    return MaterialPageRoute(
      builder: (context) {
        return ReviewsScreen(user: arguments);
      },
    );
  } else if (settings.name == AppRoutesNames.createReview) {
    final arguments = settings.arguments as UserData;
    return MaterialPageRoute(
      builder: (context) {
        return CreateReviewScreen(user: arguments);
      },
    );
  } else if (settings.name == AppRoutesNames.announcement) {
    final arguments = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AnnouncementCubit(
                announcementManager:
                    RepositoryProvider.of<AnnouncementManager>(context),
              ),
              lazy: false,
            ),
            BlocProvider(
              create: (_) => RelatedAnnouncementCubit(
                announcementManager:
                    RepositoryProvider.of<AnnouncementManager>(context),
              ),
              lazy: false,
            ),
          ],
          child: AnnouncementScreen(announcementId: arguments),
        );
      },
    );
  }

  return MaterialPageRoute(
    builder: (context) {
      return const Text('Page not found');
    },
  );
}

final appRoutes = {
  AppRoutesNames.root: (context) => const HomePage(),
  AppRoutesNames.loginFirst: (context) => const LoginFirstScreen(),
  AppRoutesNames.authCode: (context) => const CodeScreen(),
  AppRoutesNames.loginSecond: (context) => const LoginSecondScreen(),
  AppRoutesNames.register: (context) => const RegisterScreen(),
  AppRoutesNames.home: (context) => const HomeScreen(),
  AppRoutesNames.announcementCreatingCategory: (context) =>
      const CategoryScreen(),
  AppRoutesNames.announcementCreatingSubcategory: (context) =>
      const SubCategoryScreen(),
  AppRoutesNames.announcementCreatingItem: (context) =>
      const SearchProductsScreen(),
  AppRoutesNames.announcementCreatingPhoto: (context) =>
      const PickPhotosScreen(),
  AppRoutesNames.announcementCreatingType: (context) => const ByNotByScreen(),
  AppRoutesNames.announcementCreatingDescription: (context) =>
      const DescriptionScreen(),
  AppRoutesNames.announcementCreatingPlace: (context) =>
      const SearchPlaceScreen(),
  AppRoutesNames.announcementCreatingLoading: (context) =>
      const LoadingScreen(),
  AppRoutesNames.announcementCreatingOptions: (context) =>
      const OptionsScreen(),
  AppRoutesNames.main: (context) => const MainScreen(),
  // AppRoutesNames.announcement: (context) => const AnnouncementScreen(),
  AppRoutesNames.editProfile: (context) => const EditProfileScreen(),
  AppRoutesNames.settings: (context) => const SettingsScreen(),
  AppRoutesNames.announcementCreator: (context) => const CreatorProfileScreen(),
  AppRoutesNames.editingAnnouncement: (context) => const EditingAnnouncement(),
  AppRoutesNames.searchSelectSubcategory: (context) =>
      const SearchSubcategoryScreen(),
};
