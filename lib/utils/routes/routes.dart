import 'package:smart/feature/announcement/ui/announcement_screen.dart';
import 'package:smart/feature/announcement/ui/creator_screen.dart';
import 'package:smart/feature/announcement_editing/ui/editing_announcement.dart';
import 'package:smart/feature/auth/ui/code_screen.dart';
import 'package:smart/feature/auth/ui/login_first_screen.dart';
import 'package:smart/feature/auth/ui/login_second_screen.dart';
import 'package:smart/feature/auth/ui/register_screen.dart';
import 'package:smart/feature/home/ui/home_screen.dart';
import 'package:smart/feature/main/ui/main_screen.dart';
import 'package:smart/feature/profile/ui/edit_profile_screen.dart';
import 'package:smart/feature/search/ui/select_subcategory.dart';
import 'package:smart/feature/settings/ui/settings_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../feature/create_announcement/ui/creating_screens.dart';

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
  AppRoutesNames.announcementCreatingPhoto: (context) => const PickPhotosScreen(),
  AppRoutesNames.announcementCreatingType: (context) => const ByNotByScreen(),
  AppRoutesNames.announcementCreatingDescription: (context) => const DescriptionScreen(),
  AppRoutesNames.announcementCreatingPlace: (context) => const SearchPlaceScreen(),
  AppRoutesNames.announcementCreatingLoading: (context) => const LoadingScreen(),
  AppRoutesNames.announcementCreatingOptions: (context) => const OptionsScreen(),
  AppRoutesNames.main: (context) => const MainScreen(),
  AppRoutesNames.announcement: (context) => const AnnouncementScreen(),
  AppRoutesNames.editProfile: (context) => const EditProfileScreen(),
  AppRoutesNames.settings: (context) => const SettingsScreen(),
  // AppRoutesNames.search: (context) => const SearchScreen(),
  AppRoutesNames.announcementCreator: (context) => const CreatorProfileScreen(),
  // AppRoutesNames.chat: (context) => const ChatScreen(),
  AppRoutesNames.editingAnnouncement: (context) => const EditingAnnouncement(),
  AppRoutesNames.searchSelectSubcategory: (context) => const SearchSubcategoryScreen(),
};
