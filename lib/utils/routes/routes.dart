import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/announcement/announcement_cubit.dart';
import 'package:smart/feature/announcement/bloc/related/related_announcement_cubit.dart';
import 'package:smart/feature/announcement/ui/announcement_screen.dart';
import 'package:smart/feature/announcement/ui/creator_screen.dart';
import 'package:smart/feature/auth/ui/auth_error_screen.dart';
import 'package:smart/feature/auth/ui/check_code_screen.dart';
import 'package:smart/feature/auth/ui/code_screen.dart';
import 'package:smart/feature/auth/ui/login_first_screen.dart';
import 'package:smart/feature/auth/ui/login_second_screen.dart';
import 'package:smart/feature/auth/ui/registration_screen.dart';
import 'package:smart/feature/auth/ui/restore_password_screen.dart';
import 'package:smart/feature/create_announcement/ui/creating_screens.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/feature/main/ui/main_screen.dart';
import 'package:smart/feature/main/ui/sections/all_categories_page.dart';
import 'package:smart/feature/messenger/ui/chat_screen.dart';
import 'package:smart/feature/profile/ui/edit_profile_screen.dart';
import 'package:smart/feature/reviews/ui/create_review_screen.dart';
import 'package:smart/feature/reviews/ui/reviews_screen.dart';
import 'package:smart/feature/search/ui/search_screen.dart';
import 'package:smart/feature/search/ui/select_subcategory.dart';
import 'package:smart/feature/settings/ui/language_screen.dart';
import 'package:smart/feature/settings/ui/notifications_screen.dart';
import 'package:smart/feature/settings/ui/pdf_view_screen.dart';
import 'package:smart/feature/settings/ui/settings_screen.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/routes/route_names.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name!.contains('/panel/announcements-promo/')) {
    //adb shell 'am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://navigidz.online/panel/announcements-promo/?id=66f1a7d4a317c76c23dd"' dev.platovco.navigi
    final announcementId = settings.name?.split('id=').lastOrNull ?? '';
    return CustomPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AnnouncementCubit(
                announcementManager: RepositoryProvider.of<AnnouncementManager>(context),
              ),
              lazy: false,
            ),
            BlocProvider(
              create: (_) => RelatedAnnouncementCubit(
                announcementManager: RepositoryProvider.of<AnnouncementManager>(context),
              ),
              lazy: false,
            ),
          ],
          child: AnnouncementScreen(announcementId: announcementId),
        );
      },
    );
  } else if (settings.name == AppRoutesNames.loginFirst) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final showBackButton = arguments['showBackButton'] as bool?;

    return CustomPageRoute(
      builder: (context) {
        return LoginFirstScreen(
          showBackButton: showBackButton ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.authCode) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final isPasswordRestore = arguments['isPasswordRestore'] as bool?;

    return CustomPageRoute(
      builder: (context) {
        return CodeScreen(
          isPasswordRestore: isPasswordRestore ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.checkCode) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final isPasswordRestore = arguments['isPasswordRestore'] as bool?;

    return CustomPageRoute(
      builder: (context) {
        return CheckCodeScreen(
          isPasswordRestore: isPasswordRestore ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.userExist) {
    return CustomPageRoute(
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;
        return AuthErrorScreen(
          message: localizations.userAlreadyRegistered,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.userNotFound) {
    return CustomPageRoute(
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;
        return AuthErrorScreen(
          message: localizations.userNotFound,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.search) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final query = arguments['query'] as String?;
    final title = arguments['title'] as String?;
    final isSubcategory = arguments['isSubcategory'] as bool?;
    final showBackButton = arguments['showBackButton'] as bool?;
    final showSearchHelper = arguments['showSearchHelper'] as bool?;
    final showKeyboard = arguments['showKeyboard'] as bool?;
    final showCancelButton = arguments['showCancelButton'] as bool?;
    final showFilterChips = arguments['showFilterChips'] as bool?;

    return CustomPageRoute(
      builder: (context) {
        return SearchScreen(
          showCancelButton: showCancelButton ?? false,
          showFilterChips: showFilterChips ?? false,
          showBackButton: showBackButton ?? true,
          showSearchHelper: showSearchHelper ?? true,
          title: title ?? '',
          isSubcategory: isSubcategory ?? false,
          searchQueryString: query,
          showKeyboard: showKeyboard ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.chat) {
    final arguments = settings.arguments as String?;
    return CustomPageRoute(
      builder: (context) {
        return ChatScreen(message: arguments);
      },
    );
  } else if (settings.name == AppRoutesNames.reviews) {
    final arguments = settings.arguments as UserData;
    return CustomPageRoute(
      builder: (context) {
        return ReviewsScreen(user: arguments);
      },
    );
  } else if (settings.name == AppRoutesNames.createReview) {
    final arguments = settings.arguments as UserData;
    return CustomPageRoute(
      builder: (context) {
        return CreateReviewScreen(user: arguments);
      },
    );
  } else if (settings.name == AppRoutesNames.pdfView) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final fileId = arguments['fileId'] as String;
    final title = arguments['title'] as String;
    return CustomPageRoute(
      builder: (context) {
        return PdfViewScreen(
          fileId: fileId,
          title: title,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.announcement) {
    final arguments = settings.arguments as String;

    return CustomPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AnnouncementCubit(
                announcementManager: RepositoryProvider.of<AnnouncementManager>(context),
              ),
              lazy: false,
            ),
            BlocProvider(
              create: (_) => RelatedAnnouncementCubit(
                announcementManager: RepositoryProvider.of<AnnouncementManager>(context),
              ),
              lazy: false,
            ),
          ],
          child: AnnouncementScreen(announcementId: arguments),
        );
      },
    );
  }
  final otherRoute = appRoutes[settings.name];
  if (otherRoute != null) {
    return CustomPageRoute(builder: otherRoute);
  }

  return CustomPageRoute(
    builder: (context) {
      return const Text('Page not found');
    },
  );
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration {
    if (Platform.isIOS) {
      return const Duration(milliseconds: 300);
    } else {
      return const Duration(milliseconds: 0);
    }
  }
}

final appRoutes = {
  AppRoutesNames.restorePassword: (context) => const RestorePasswordScreen(),
  AppRoutesNames.loginSecond: (context) => const LoginSecondScreen(),
  AppRoutesNames.register: (context) => const RegistrationScreen(),
  AppRoutesNames.home: (context) => const HomeScreen(),
  AppRoutesNames.announcementCreatingCategory: (context) => const CategoryScreen(),
  AppRoutesNames.announcementCreatingSubcategory: (context) => const SubCategoryScreen(),
  AppRoutesNames.announcementCreatingTitle: (context) => const SearchProductsScreen(),
  AppRoutesNames.announcementCreatingPhoto: (context) => const PickPhotosScreen(),
  AppRoutesNames.announcementCreatingType: (context) => const ByNotByScreen(),
  AppRoutesNames.announcementCreatingDescription: (context) => const DescriptionScreen(),
  AppRoutesNames.announcementCreatingPlace: (context) => const SearchPlaceScreen(),
  AppRoutesNames.announcementCreatingLoading: (context) => const LoadingScreen(),
  AppRoutesNames.announcementCreatingOptions: (context) => const OptionsScreen(),
  AppRoutesNames.main: (context) => const MainScreen(),
  AppRoutesNames.editProfile: (context) => const EditProfileScreen(),
  AppRoutesNames.settings: (context) => const SettingsScreen(),
  AppRoutesNames.settingsLanguage: (context) => const LanguageScreen(),
  AppRoutesNames.notifications: (context) => const NotificationsScreen(),
  AppRoutesNames.announcementCreator: (context) => const CreatorProfileScreen(),
  AppRoutesNames.searchSelectSubcategory: (context) => const SearchSubcategoryScreen(),
  AppRoutesNames.allCategories: (context) => const AllCategoriesPage(),
};
