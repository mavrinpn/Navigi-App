import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/announcement/announcement_cubit.dart';
import 'package:smart/feature/announcement/bloc/related/related_announcement_cubit.dart';
import 'package:smart/feature/announcement/ui/announcement_screen.dart';
import 'package:smart/feature/announcement/ui/creator_screen.dart';
import 'package:smart/feature/announcement_editing/ui/editing_announcement_screen.dart';
import 'package:smart/feature/auth/ui/auth_error_screen.dart';
import 'package:smart/feature/auth/ui/check_code_screen.dart';
import 'package:smart/feature/auth/ui/code_screen.dart';
import 'package:smart/feature/auth/ui/login_first_screen.dart';
import 'package:smart/feature/auth/ui/login_second_screen.dart';
import 'package:smart/feature/auth/ui/registration_screen.dart';
import 'package:smart/feature/auth/ui/restore_password_screen.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/feature/main/ui/main_page.dart';
import 'package:smart/feature/main/ui/main_screen.dart';
import 'package:smart/feature/messenger/ui/chat_screen.dart';
import 'package:smart/feature/profile/ui/edit_profile_screen.dart';
import 'package:smart/feature/reviews/ui/create_review_screen.dart';
import 'package:smart/feature/reviews/ui/reviews_screen.dart';
import 'package:smart/feature/search/ui/search_screen.dart';
import 'package:smart/feature/search/ui/select_subcategory.dart';
import 'package:smart/feature/settings/ui/language_screen.dart';
import 'package:smart/feature/settings/ui/pdf_view_screen.dart';
import 'package:smart/feature/settings/ui/settings_screen.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../feature/create_announcement/ui/creating_screens.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == AppRoutesNames.loginFirst) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final showBackButton = arguments['showBackButton'] as bool?;

    return MaterialPageRoute(
      builder: (context) {
        return LoginFirstScreen(
          showBackButton: showBackButton ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.authCode) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final isPasswordRestore = arguments['isPasswordRestore'] as bool?;

    return MaterialPageRoute(
      builder: (context) {
        return CodeScreen(
          isPasswordRestore: isPasswordRestore ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.checkCode) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final isPasswordRestore = arguments['isPasswordRestore'] as bool?;

    return MaterialPageRoute(
      builder: (context) {
        return CheckCodeScreen(
          isPasswordRestore: isPasswordRestore ?? false,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.userExist) {
    return MaterialPageRoute(
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;
        return AuthErrorScreen(
          message: localizations.userAlreadyRegistered,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.userNotFound) {
    return MaterialPageRoute(
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
    final showBackButton = arguments['showBackButton'] as bool?;
    final showSearchHelper = arguments['showSearchHelper'] as bool?;
    final showKeyboard = arguments['showKeyboard'] as bool?;

    return customFadeTransition(
      builder: (context) {
        return SearchScreen(
          showBackButton: showBackButton ?? true,
          showSearchHelper: showSearchHelper ?? true,
          title: title ?? '',
          searchQueryString: query,
          showKeyboard: showKeyboard ?? false,
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
  } else if (settings.name == AppRoutesNames.pdfView) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final fileId = arguments['fileId'] as String;
    final title = arguments['title'] as String;
    return MaterialPageRoute(
      builder: (context) {
        return PdfViewScreen(
          fileId: fileId,
          title: title,
        );
      },
    );
  } else if (settings.name == AppRoutesNames.announcement) {
    final arguments = settings.arguments as String;

    return customFadeTransition(
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

  return MaterialPageRoute(
    builder: (context) {
      return const Text('Page not found');
    },
  );
}

//TODO customFadeTransition
customFadeTransition({required Widget Function(BuildContext) builder}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return builder(context);
    },
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

// customSlideTransition({required Widget Function(BuildContext) builder}) {
//   return PageRouteBuilder(
//     transitionDuration: const Duration(milliseconds: 300),
//     reverseTransitionDuration: const Duration(milliseconds: 300),
//     pageBuilder: (
//       BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//     ) {
//       return builder(context);
//     },
//     transitionsBuilder: (
//       BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child,
//     ) {
//       const begin = Offset(1.0, 0.0);
//       const end = Offset.zero;
//       final tween = Tween(begin: begin, end: end);
//       final offsetAnimation = animation.drive(tween);

//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//   );
// }

final appRoutes = {
  AppRoutesNames.root: (context) => const MainPage(),
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
  AppRoutesNames.announcementCreator: (context) => const CreatorProfileScreen(),
  AppRoutesNames.editingAnnouncement: (context) => const EditingAnnouncementScreen(),
  AppRoutesNames.searchSelectSubcategory: (context) => const SearchSubcategoryScreen(),
};
