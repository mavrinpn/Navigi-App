import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

const notificationsCommonKey = 'notifications_common';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<bool> paramList = [true, false];
  bool? isNotificationsEnabled;

  late final AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = RepositoryProvider.of<AuthRepository>(context);
    getParam();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        titleSpacing: 6,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomBackButton(),
            Expanded(
              child: Text(
                localizations.placeApplicationSettings,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTypography.font20black,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('Assets/icons/notifications.svg'),
                const SizedBox(width: 16),
                Text(
                  localizations.notifications,
                  style: AppTypography.font18black,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: paramList
                  .map((e) => GestureDetector(
                        onTap: () => onParamSelected(e),
                        child: Row(
                          children: [
                            CustomCheckBox(
                              isActive: e == isNotificationsEnabled,
                              onChanged: () => onParamSelected(e),
                            ),
                            Text(
                              e ? localizations.enabled : localizations.disabled,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: AppTypography.font14black.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void getParam() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isNotificationsEnabled = prefs.getBool(notificationsCommonKey) ?? true;
    setState(() {});
  }

  void onParamSelected(bool param) async {
    isNotificationsEnabled = param;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationsCommonKey, param);

    authRepository.initNotification();

    setState(() {});
  }
}
